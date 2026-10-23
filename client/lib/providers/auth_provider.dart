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

  /// Guests and signed-out users both hit the same feature restrictions.
  bool get isRestricted =>
      isGuest || status == AuthStatus.unauthenticated;
}

class AuthNotifier extends Notifier<AuthState> {
  SupabaseClient get _client => Supabase.instance.client;

  final _routerRefreshNotifier = _RouterRefreshNotifier();
  ChangeNotifier get refreshNotifier => _routerRefreshNotifier;

  static bool? _onboardedCache;
  static DateTime? _onboardedCacheTime;

  void _emit(AuthState newState) {
    state = newState;
    _routerRefreshNotifier.notify();
  }

  UserModel _userFromSession(User u, {bool onboarded = false}) {
    return UserModel(
      id: u.id,
      email: u.email,
      phone: u.phone,
      displayName: u.userMetadata?['display_name'] as String?,
      avatarUrl: u.userMetadata?['avatar_url'] as String?,
      role: 'USER',
      onboarded: onboarded,
      createdAt: DateTime.now(),
    );
  }

  Future<bool> _fetchOnboarded() async {
    // Use in-memory cache (5 min TTL)
    if (_onboardedCache != null && _onboardedCacheTime != null) {
      if (DateTime.now().difference(_onboardedCacheTime!).inMinutes < 5) {
        return _onboardedCache!;
      }
    }
    try {
      final data = await ApiService.instance.getOnboardedStatus();
      final result = data['onboarded'] as bool? ?? false;
      _onboardedCache = result;
      _onboardedCacheTime = DateTime.now();
      return result;
    } catch (_) {
      return _onboardedCache ?? false;
    }
  }

  @override
  AuthState build() {
    try {
      final session = _client.auth.currentSession;
      if (session != null) {
        _listenToAuthChanges();
        final user = session.user;
        final cachedOnboarded = StorageService.getSetting<bool>('onboarded') ?? false;
        final initialState = AuthState(
          status: AuthStatus.authenticated,
          user: _userFromSession(user, onboarded: cachedOnboarded),
        );
        // Lazy sync: fetch onboarded in background, update if changed
        Future.microtask(() async {
          final onboarded = await _fetchOnboarded();
          await StorageService.setSetting('onboarded', onboarded);
          final currentUser = state.user;
          if (currentUser != null && currentUser.id == user.id && currentUser.onboarded != onboarded) {
            _emit(AuthState(
              status: state.status,
              user: _userFromSession(user, onboarded: onboarded),
            ));
          }
        });
        return initialState;
      }
    } catch (_) {
      // Supabase unavailable — fall through to guest/unauthenticated restore.
    }
    _listenToAuthChanges();
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
            event == AuthChangeEvent.passwordRecovery ||
            event == AuthChangeEvent.tokenRefreshed) {
          if (session != null) {
            final user = session.user;
            if (event == AuthChangeEvent.signedIn) {
              // Emit immediately with cached onboarded (non-blocking)
              final cachedOnboarded = StorageService.getSetting<bool>('onboarded') ?? false;
              _emit(
                AuthState(
                  status: AuthStatus.authenticated,
                  user: _userFromSession(user, onboarded: cachedOnboarded),
                ),
              );
              // Fetch real onboarded in background (non-blocking)
              StorageService.clearUserCache();
              _fetchOnboarded().then((onboarded) async {
                await StorageService.setSetting('onboarded', onboarded);
                if (state.user?.id == user.id && state.user?.onboarded != onboarded) {
                  _emit(
                    AuthState(
                      status: state.status,
                      user: _userFromSession(user, onboarded: onboarded),
                    ),
                  );
                }
              });
            } else {
              // Token refresh: use cached onboarded, don't make API call
              final cachedOnboarded = StorageService.getSetting<bool>('onboarded') ?? false;
              _emit(
                AuthState(
                  status: AuthStatus.authenticated,
                  user: _userFromSession(user, onboarded: cachedOnboarded),
                ),
              );
            }
          }
        } else if (event == AuthChangeEvent.signedOut) {
          await StorageService.clearAllUserData();
          ref.read(taxProvider.notifier).reset();
          await StorageService.setSetting('onboarded', false);
          // A fresh sign-out must land on the login screen, not restore a
          // guest session chosen earlier.
          await StorageService.setSetting('guest', false);
          _onboardedCache = null;
          _onboardedCacheTime = null;
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
      await StorageService.clearUserCache();
      // Use cached onboarded status — don't block sign-in on API call
      final cachedOnboarded = StorageService.getSetting<bool>('onboarded') ?? false;
      _emit(
        AuthState(
          status: AuthStatus.authenticated,
          user: _userFromSession(u, onboarded: cachedOnboarded),
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
      // New user: onboarded is always false
      await StorageService.setSetting('onboarded', false);
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
      await StorageService.clearUserCache();
      final onboarded = await _fetchOnboarded();
      _emit(
        AuthState(
          status: AuthStatus.authenticated,
          user: _userFromSession(u, onboarded: onboarded),
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
      await StorageService.clearUserCache();
      final cachedOnboarded =
          StorageService.getSetting<bool>('onboarded') ?? false;
      _emit(
        AuthState(
          status: AuthStatus.authenticated,
          user: _userFromSession(u, onboarded: cachedOnboarded),
        ),
      );
      // Background sync of the onboarded flag (mirrors sign-in).
      _fetchOnboarded().then((onboarded) async {
        await StorageService.setSetting('onboarded', onboarded);
        if (state.user?.id == u.id && state.user?.onboarded != onboarded) {
          _emit(AuthState(
            status: state.status,
            user: _userFromSession(u, onboarded: onboarded),
          ));
        }
      });
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
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: _getRedirectUrl(),
      );
      return;
    }

    final googleSignIn = GoogleSignIn(
      serverClientId: AppConstants.googleWebClientId,
    );
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

  Future<void> signOut() async {
    await _client.auth.signOut();
    await StorageService.clearAllUserData();
    await StorageService.clearAllSettingsExcept(['darkMode']);
    ref.read(taxProvider.notifier).reset();
    _onboardedCache = null;
    _onboardedCacheTime = null;
    _emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  Future<void> completeOnboarding() async {
    final current = state.user;
    if (current == null) return;
    try {
      await ApiService.instance.completeOnboarding();
    } catch (_) {
      // Server update failed — still update local state so user can proceed
    }
    await StorageService.setSetting('onboarded', true);
    _onboardedCache = true;
    _onboardedCacheTime = DateTime.now();
    _emit(AuthState(
      status: state.status,
      user: UserModel(
        id: current.id,
        email: current.email,
        phone: current.phone,
        displayName: current.displayName,
        role: current.role,
        avatarUrl: current.avatarUrl,
        onboarded: true,
        createdAt: current.createdAt,
      ),
    ));
  }

  Future<void> updateAvatar(String avatarUrl) async {
    final previous = state.user?.avatarUrl;
    _applyLocalUser(avatarUrl: avatarUrl);
    try {
      await ApiService.instance.updateAvatar(avatarUrl);
      await _client.auth.updateUser(
        UserAttributes(data: {'avatar_url': avatarUrl}),
      );
    } catch (_) {
      // Persist failed — roll back so the UI matches the server.
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
          role: current.role,
          avatarUrl: avatarUrl ?? current.avatarUrl,
          address: address ?? current.address,
          onboarded: current.onboarded,
          createdAt: current.createdAt,
        ),
      ),
    );
  }

  /// Pulls the DB profile (address etc.) and merges into local state.
  Future<void> fetchMe() async {
    if (!state.isAuthenticated) return;
    try {
      final data = await ApiService.instance.getMe();
      _applyLocalUser(
        displayName: data['displayName'] as String?,
        phone: data['phone'] as String?,
        address: data['address'] as String?,
        avatarUrl: data['avatarUrl'] as String?,
      );
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
