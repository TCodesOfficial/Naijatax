import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'tax_provider.dart';

String _getRedirectUrl() {
  if (kIsWeb) {
    return '${Uri.base.origin}/';
  }
  return 'naijatax://';
}

enum AuthStatus {
  loading,

  /// A session exists but onboarding status is still being confirmed with
  /// the server. The router parks the user on a splash screen so neither
  /// onboarding nor the dashboard flashes before the answer is known.
  resolving,
  authenticated,
  guest,
  unauthenticated,
  awaitingConfirmation,
}

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final bool needsOtpVerification;
  final String? pendingPhone;
  final String? pendingEmail;

  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.needsOtpVerification = false,
    this.pendingPhone,
    this.pendingEmail,
  });

  bool get isGuest => status == AuthStatus.guest;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isResolving => status == AuthStatus.resolving;

  /// Guests and signed-out users both hit the same feature restrictions.
  bool get isRestricted =>
      isGuest || status == AuthStatus.unauthenticated;
}

class AuthNotifier extends Notifier<AuthState> {
  SupabaseClient get _client => Supabase.instance.client;

  final _routerRefreshNotifier = _RouterRefreshNotifier();
  ChangeNotifier get refreshNotifier => _routerRefreshNotifier;

  /// Onboarding status is stored per user so accounts sharing a device
  /// never inherit each other's completed state.
  static String _onboardedKey(String userId) => 'onboarded_$userId';

  void _emit(AuthState newState) {
    state = newState;
    _routerRefreshNotifier.notify();
  }

  UserModel _userFromSession(User u, {bool onboarded = false}) {
    // Prefer the last server profile (/users/me) cached for this user so
    // fields the session doesn't carry (role, address) never blank out.
    final cached = StorageService.getUserProfile(u.id);
    return UserModel(
      id: u.id,
      email: u.email,
      phone: cached?['phone'] as String? ?? u.phone,
      displayName: cached?['displayName'] as String? ??
          u.userMetadata?['display_name'] as String? ??
          u.userMetadata?['full_name'] as String?,
      avatarUrl: _customAvatar(u) ??
          cached?['avatarUrl'] as String? ??
          u.userMetadata?['avatar_url'] as String?,
      address: cached?['address'] as String?,
      role: cached?['role'] as String? ?? 'USER',
      onboarded: onboarded,
      createdAt: DateTime.now(),
    );
  }

  /// A photo the user uploaded themselves. Stored under its own metadata key
  /// because Google sign-in rewrites `avatar_url` with the Google photo on
  /// every login, which used to replace the user's chosen picture.
  String? _customAvatar(User? u) {
    final v = u?.userMetadata?['custom_avatar_url'];
    return v is String ? v : null;
  }

  /// True for accounts created in the last few minutes — used only when the
  /// server can't be reached, so brand-new users still see onboarding while
  /// returning users are never sent through it again.
  bool _isNewAccount(User u) {
    final created = DateTime.tryParse(u.createdAt);
    if (created == null) return false;
    return DateTime.now().toUtc().difference(created.toUtc()) <
        const Duration(minutes: 15);
  }

  /// Instant onboarding answer with no network call: the Supabase user
  /// metadata (travels inside the session) or this device's cached `true`.
  /// A cached `false` is never trusted — the user may have finished
  /// onboarding elsewhere — so anything but a confirmed `true` means
  /// "ask the server".
  bool _knownOnboarded(User u) {
    if (u.userMetadata?['onboarded'] == true) return true;
    return StorageService.getSetting<bool>(_onboardedKey(u.id)) == true;
  }

  /// Persists a confirmed onboarded state locally and in Supabase metadata,
  /// so every later sign-in (any device) can route instantly.
  Future<void> _markOnboarded(String userId, {User? user}) async {
    await StorageService.setSetting(_onboardedKey(userId), true);
    await StorageService.setSetting('onboarded', true);
    if (user?.userMetadata?['onboarded'] == true) return;
    unawaited(
      _client.auth
          .updateUser(UserAttributes(data: {'onboarded': true}))
          .then((_) {}, onError: (_) {}),
    );
  }

  /// Server-truth onboarding flag, or null when the request failed.
  /// Failures must never surface as `false` — a network blip would erase a
  /// previous "onboarded" state and send returning users to onboarding.
  Future<bool?> _fetchOnboardedFromServer({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    try {
      final data =
          await ApiService.instance.getOnboardedStatus().timeout(timeout);
      return data['onboarded'] as bool? ?? false;
    } catch (_) {
      return null;
    }
  }

  // De-duplicates concurrent session setup for the same user (the explicit
  // sign-in call and the signedIn auth event both arrive at once).
  Future<void>? _establishing;
  String? _establishingUserId;

  /// Single entry point that turns a Supabase user into an authenticated
  /// app state with a trustworthy onboarding flag.
  Future<void> _establishSession(User u, {bool freshSignIn = false}) {
    final pending = _establishing;
    if (pending != null && _establishingUserId == u.id) return pending;
    _establishingUserId = u.id;
    final future = _doEstablishSession(u, freshSignIn).whenComplete(() {
      _establishing = null;
      _establishingUserId = null;
    });
    _establishing = future;
    return future;
  }

  Future<void> _doEstablishSession(User u, bool freshSignIn) async {
    if (freshSignIn) {
      await StorageService.clearUserCache();
      ref.read(taxProvider.notifier).reset();
    }

    if (_knownOnboarded(u)) {
      _emit(AuthState(
        status: AuthStatus.authenticated,
        user: _userFromSession(u, onboarded: true),
      ));
    } else {
      _emit(const AuthState(status: AuthStatus.resolving));
      final serverValue = await _fetchOnboardedFromServer();
      // Signed out (or switched account) while waiting — drop the result.
      if (_client.auth.currentUser?.id != u.id) return;
      // Server unreachable (e.g. the free Render instance waking up): only
      // brand-new accounts go to onboarding; everyone else goes straight in.
      final onboarded = serverValue ?? !_isNewAccount(u);
      if (onboarded) await _markOnboarded(u.id, user: u);
      _emit(AuthState(
        status: AuthStatus.authenticated,
        user: _userFromSession(u, onboarded: onboarded),
      ));
    }
    // Full profile sync (role, address, avatar) in the background.
    unawaited(fetchMe());
  }

  @override
  AuthState build() {
    _listenToAuthChanges();
    try {
      final session = _client.auth.currentSession;
      if (session != null) {
        final user = session.user;
        if (_knownOnboarded(user)) {
          Future.microtask(fetchMe);
          return AuthState(
            status: AuthStatus.authenticated,
            user: _userFromSession(user, onboarded: true),
          );
        }
        // Unknown onboarding state: hold on the splash screen until the
        // server answers instead of guessing (the old guess caused the
        // onboarding screen to flash before the dashboard).
        Future.microtask(() => _establishSession(user));
        return const AuthState(status: AuthStatus.resolving);
      }
    } catch (_) {
      // Supabase unavailable — fall through to guest/unauthenticated restore.
    }
    // A guest from the previous run stays a guest across restarts (a real
    // session, checked above, always wins).
    if (StorageService.getSetting<bool>('guest') == true) {
      return const AuthState(status: AuthStatus.guest);
    }
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  void _listenToAuthChanges() {
    try {
      _client.auth.onAuthStateChange.listen((data) async {
        final event = data.event;
        final session = data.session;
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.passwordRecovery) {
          if (session == null) return;
          final user = session.user;
          // Already set up for this user (e.g. the stream replaying the
          // OAuth sign-in that build() already restored) — nothing to do.
          if (state.isAuthenticated && state.user?.id == user.id) return;
          await _establishSession(user, freshSignIn: true);
        } else if (event == AuthChangeEvent.tokenRefreshed) {
          // Same user, new token: keep the current state untouched. Rebuilding
          // it from the session used to wipe the address/role from fetchMe.
          // Only recover if we somehow ended up signed out with a live session.
          if (session != null && state.status == AuthStatus.unauthenticated) {
            await _establishSession(session.user);
          }
        } else if (event == AuthChangeEvent.signedOut) {
          await StorageService.clearAllUserData();
          ref.read(taxProvider.notifier).reset();
          // A fresh sign-out must land on the login screen, not restore a
          // guest session chosen earlier.
          await StorageService.setSetting('guest', false);
          _emit(const AuthState(status: AuthStatus.unauthenticated));
        }
      });
    } catch (_) {
      // Supabase not initialized
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _emit(const AuthState(status: AuthStatus.loading));
    try {
      final res = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final u = res.user;
      if (u == null) {
        _emit(
          const AuthState(
            status: AuthStatus.unauthenticated,
            error: 'Sign in failed. Please try again.',
          ),
        );
        return;
      }
      await _establishSession(u, freshSignIn: true);
    } on AuthException catch (e) {
      _emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (_) {
      _emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Connection failed. Please check your network and try again.',
        ),
      );
    }
  }

  Future<void> signUpWithEmail(
    String email,
    String password, {
    String? displayName,
  }) async {
    _emit(const AuthState(status: AuthStatus.loading));
    try {
      final res = await _client.auth.signUp(
        email: email,
        password: password,
        data: displayName != null ? {'display_name': displayName} : null,
      );
      final u = res.user;
      if (u == null) {
        _emit(
          const AuthState(
            status: AuthStatus.unauthenticated,
            error: 'Sign up failed. Please try again.',
          ),
        );
        return;
      }
      if (res.session == null) {
        _emit(
          AuthState(
            status: AuthStatus.awaitingConfirmation,
            pendingEmail: email,
          ),
        );
        return;
      }
      await StorageService.clearUserCache();
      _emit(
        AuthState(
          status: AuthStatus.authenticated,
          user: _userFromSession(u, onboarded: false),
        ),
      );
    } on AuthException catch (e) {
      final msg = e.message.toLowerCase();
      if (msg.contains('already') || msg.contains('registered')) {
        _emit(
          const AuthState(
            status: AuthStatus.unauthenticated,
            error:
                'An account with this email already exists. Please sign in instead.',
          ),
        );
      } else {
        _emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
      }
    } catch (_) {
      _emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Connection failed. Please check your network and try again.',
        ),
      );
    }
  }

  Future<void> resendConfirmation() async {
    final email = state.pendingEmail;
    if (email == null) return;
    try {
      await _client.auth.resend(email: email, type: OtpType.signup);
    } on AuthException catch (_) {
      // Silently fail — user can retry
    }
  }

  // ─── Phone Authentication ───────────────────────────────────────────────

  Future<void> signInWithPhone(String phone) async {
    _emit(const AuthState(status: AuthStatus.loading));
    try {
      await _client.auth.signInWithOtp(phone: phone);
      _emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          needsOtpVerification: true,
          pendingPhone: phone,
        ),
      );
    } on AuthException catch (e) {
      _emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (_) {
      _emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Connection failed. Please check your network and try again.',
        ),
      );
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    _emit(const AuthState(status: AuthStatus.loading));
    try {
      final res = await _client.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      final u = res.user;
      if (u == null) {
        _emit(
          const AuthState(
            status: AuthStatus.unauthenticated,
            error: 'Invalid OTP. Please try again.',
          ),
        );
        return;
      }
      await _establishSession(u, freshSignIn: true);
    } on AuthException catch (e) {
      _emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (_) {
      _emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Connection failed. Please check your network and try again.',
        ),
      );
    }
  }

  Future<void> signUpWithPhone(String phone, String password) async {
    _emit(const AuthState(status: AuthStatus.loading));
    try {
      await _client.auth.signUp(phone: phone, password: password);
      _emit(
        AuthState(
          status: AuthStatus.unauthenticated,
          needsOtpVerification: true,
          pendingPhone: phone,
        ),
      );
    } on AuthException catch (e) {
      _emit(AuthState(status: AuthStatus.unauthenticated, error: e.message));
    } catch (_) {
      _emit(
        const AuthState(
          status: AuthStatus.unauthenticated,
          error: 'Connection failed. Please check your network and try again.',
        ),
      );
    }
  }

  // ─── Password recovery (email OTP) ──────────────────────────────────────
  // Server has no auth endpoints — this flow talks to Supabase directly.

  /// Sends a 6-digit recovery code to [email].
  /// Returns null on success, a friendly message on failure.
  Future<String?> sendPasswordResetOtp(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email.trim());
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not send the code. Please check your connection and try again.';
    }
  }

  /// Verifies the recovery code and establishes a session (Supabase's
  /// passwordRecovery/signedIn events may also fire — both are handled).
  /// Returns null on success, a friendly message on failure.
  Future<String?> verifyRecoveryOtp(String email, String token) async {
    try {
      final res = await _client.auth.verifyOTP(
        email: email.trim(),
        token: token.trim(),
        type: OtpType.recovery,
      );
      final u = res.user;
      if (res.session == null || u == null) {
        return 'Invalid or expired code. Request a new one.';
      }
      await _establishSession(u, freshSignIn: true);
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not verify the code. Please try again.';
    }
  }

  /// Sets the new password for the session created by [verifyRecoveryOtp].
  /// Returns null on success, a friendly message on failure.
  Future<String?> setNewPassword(String password) async {
    try {
      await _client.auth.updateUser(UserAttributes(password: password));
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Could not update the password. Please try again.';
    }
  }

  // ─── OAuth ──────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      // prompt=select_account forces Google's account chooser even when the
      // browser already holds an active Google session.
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _getRedirectUrl(),
        queryParams: const {'prompt': 'select_account'},
      );
      return;
    }

    // iOS: native google_sign_in was never configured (no GIDClientID /
    // REVERSED_CLIENT_ID in Info.plist), so use the browser OAuth flow —
    // the previously-working path, which always offers Google's chooser.
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'naijatax://',
        queryParams: const {'prompt': 'select_account'},
      );
      return;
    }

    final googleSignIn = GoogleSignIn(
      serverClientId: AppConstants.googleWebClientId,
    );
    // Clear any cached identity so the chooser always appears instead of
    // silently resuming the previously signed-in account.
    await googleSignIn.signOut();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) throw 'Google sign-in was cancelled';
    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    final accessToken = googleAuth.accessToken;

    if (idToken == null || accessToken == null) {
      throw 'Google sign-in failed: missing tokens';
    }

    await StorageService.clearUserCache();
    await _client.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> continueAsGuest() async {
    await StorageService.setSetting('guest', true);
    _emit(const AuthState(status: AuthStatus.guest));
  }

  /// A guest chose to log in or sign up. The guest session must end first:
  /// the router treats guests like signed-in users and would otherwise
  /// bounce them from the landing/login screens back to the dashboard.
  Future<void> leaveGuestMode() async {
    if (!state.isGuest) return;
    await StorageService.setSetting('guest', false);
    _emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    await StorageService.clearAllUserData();
    // Onboarding flags survive sign-out: they describe the account, not the
    // session, and wiping them made the next sign-in guess "not onboarded".
    await StorageService.clearAllSettingsExcept(
      ['darkMode', 'onboarded'],
      keepPrefixes: ['onboarded_'],
    );
    ref.read(taxProvider.notifier).reset();
    _emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  /// Marks onboarding done immediately so Skip / Done respond at once; the
  /// server is told in the background (it can take seconds to wake up).
  Future<void> completeOnboarding() async {
    final current = state.user;
    if (current == null) return;
    // Keeps address and other synced fields (the old rebuild dropped them).
    _applyLocalUser(onboarded: true);
    await _markOnboarded(current.id, user: _client.auth.currentUser);
    unawaited(
      ApiService.instance.completeOnboarding().then((_) {}, onError: (_) {}),
    );
  }

  /// Saves the photo to both the account metadata and the server profile.
  /// Only rolls back if neither save worked; one success is enough for the
  /// new photo to survive a restart.
  Future<void> updateAvatar(String avatarUrl) async {
    final previous = state.user?.avatarUrl;
    _applyLocalUser(avatarUrl: avatarUrl);
    var saved = false;
    try {
      await _client.auth.updateUser(
        UserAttributes(data: {'custom_avatar_url': avatarUrl}),
      );
      saved = true;
    } catch (_) {}
    try {
      await ApiService.instance.updateAvatar(avatarUrl);
      saved = true;
    } catch (_) {}
    final id = state.user?.id;
    if (saved && id != null) {
      final cached = StorageService.getUserProfile(id) ?? <String, dynamic>{};
      await StorageService.saveUserProfile(id, {...cached, 'avatarUrl': avatarUrl});
    } else if (!saved) {
      _applyLocalUser(avatarUrl: previous ?? '');
    }
  }

  Future<void> deleteAvatar() async {
    await updateAvatar('');
  }

  /// Updates only the provided fields of the local user, preserving the rest.
  void _applyLocalUser({
    String? displayName,
    String? phone,
    String? address,
    String? avatarUrl,
    String? role,
    bool? onboarded,
  }) {
    final current = state.user;
    if (current == null) return;
    _emit(
      AuthState(
        status: state.status,
        user: UserModel(
          id: current.id,
          email: current.email,
          phone: phone ?? current.phone,
          displayName: displayName ?? current.displayName,
          role: role ?? current.role,
          avatarUrl: avatarUrl ?? current.avatarUrl,
          address: address ?? current.address,
          onboarded: onboarded ?? current.onboarded,
          createdAt: current.createdAt,
        ),
      ),
    );
  }

  /// Pulls the DB profile (address, role, avatar…) and merges into local
  /// state, then stores the fresh copy in Hive for the next cold start.
  Future<void> fetchMe() async {
    if (!state.isAuthenticated) return;
    final current = state.user;
    if (current == null) return;
    try {
      final data = await ApiService.instance.getMe();
      _applyLocalUser(
        displayName: data['displayName'] as String?,
        phone: data['phone'] as String?,
        address: data['address'] as String?,
        // A photo the user chose wins over the server copy, which may still
        // hold the Google picture if the server save failed earlier.
        avatarUrl: _customAvatar(_client.auth.currentUser) ??
            data['avatarUrl'] as String?,
        role: data['role'] as String?,
      );
      await StorageService.saveUserProfile(current.id, data);
      if (data['onboarded'] == true) {
        await _markOnboarded(current.id, user: _client.auth.currentUser);
      }
    } catch (_) {
      // Offline / server unreachable — keep local state
    }
  }

  /// Updates the display name in Supabase metadata + the server DB.
  /// Returns null on success, an error message otherwise.
  Future<String?> updateDisplayName(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return 'Name cannot be empty';
    if (state.user == null) return 'Not signed in';

    try {
      await _client.auth.updateUser(
        UserAttributes(data: {'display_name': trimmed}),
      );
    } catch (e) {
      return 'Could not update name: $e';
    }
    _applyLocalUser(displayName: trimmed);
    try {
      await ApiService.instance.updateProfile(displayName: trimmed);
    } catch (_) {
      // DB sync failed — metadata already updated
    }
    return null;
  }

  /// Saves the residential address to the server DB only.
  Future<String?> updateAddress(String address) async {
    if (state.user == null) return 'Not signed in';
    try {
      final data = await ApiService.instance.updateProfile(address: address);
      _applyLocalUser(address: data['address'] as String? ?? address);
      return null;
    } catch (e) {
      return 'Could not save address: $e';
    }
  }

  /// Triggers a phone-change OTP to [phone] via Supabase.
  /// Returns null on success (code sent), an error message otherwise.
  Future<String?> changePhone(String phone) async {
    if (state.user == null) return 'Not signed in';
    try {
      await _client.auth.updateUser(UserAttributes(phone: phone));
      _emit(
        AuthState(
          status: state.status,
          user: state.user,
          pendingPhone: phone,
        ),
      );
      return null;
    } catch (e) {
      return 'Could not send code: $e';
    }
  }

  /// Verifies the OTP sent by [changePhone] and persists the new phone.
  Future<String?> verifyPhoneChange(String phone, String otp) async {
    if (state.user == null) return 'Not signed in';
    try {
      await _client.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.phoneChange,
      );
    } catch (e) {
      return 'Invalid code: $e';
    }
    _applyLocalUser(phone: phone);
    _emit(
      AuthState(
        status: state.status,
        user: state.user,
      ),
    );
    try {
      await ApiService.instance.updateProfile(phone: phone);
    } catch (_) {
      // DB sync failed — Supabase already updated
    }
    return null;
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
