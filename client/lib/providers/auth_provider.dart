import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import 'tax_provider.dart';

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
      return const AuthState(status: AuthStatus.unauthenticated);
    }
    _listenToAuthChanges();
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  void _listenToAuthChanges() {
    try {
      _client.auth.onAuthStateChange.listen((data) async {
        final event = data.event;
        final session = data.session;
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.tokenRefreshed) {
          if (session != null) {
            final user = session.user;
            if (event == AuthChangeEvent.signedIn) {
              await StorageService.clearUserCache();
              // Only fetch onboarded on fresh sign-in, not token refresh
              final onboarded = await _fetchOnboarded();
              await StorageService.setSetting('onboarded', onboarded);
              _emit(
                AuthState(
                  status: AuthStatus.authenticated,
                  user: _userFromSession(user, onboarded: onboarded),
                ),
              );
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

  // ─── OAuth ──────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    if (kIsWeb) {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'https://skxiwgqhzjxvvlrcmxxh.supabase.co/auth/v1/callback',
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

  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.apple,
      redirectTo: 'https://skxiwgqhzjxvvlrcmxxh.supabase.co/auth/v1/callback',
    );
  }

  Future<void> signInWithFacebook() async {
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.facebook,
        redirectTo: 'https://skxiwgqhzjxvvlrcmxxh.supabase.co/auth/v1/callback',
      );
    } catch (e) {
      throw 'Facebook sign-in failed. Please try again.';
    }
  }

  void continueAsGuest() {
    _emit(const AuthState(status: AuthStatus.guest));
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    await StorageService.clearAllUserData();
    ref.read(taxProvider.notifier).reset();
    await StorageService.setSetting('onboarded', false);
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
    final current = state.user;
    if (current == null) return;
    _emit(
      AuthState(
        status: state.status,
        user: UserModel(
          id: current.id,
          email: current.email,
          phone: current.phone,
          displayName: current.displayName,
          role: current.role,
          avatarUrl: avatarUrl,
          onboarded: current.onboarded,
          createdAt: current.createdAt,
        ),
      ),
    );
    try {
      await ApiService.instance.updateAvatar(avatarUrl);
      await _client.auth.updateUser(
        UserAttributes(data: {'avatar_url': avatarUrl}),
      );
    } catch (_) {
      // Server/metadata persist failed — local state already updated
    }
  }

  Future<void> deleteAvatar() async {
    await updateAvatar('');
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);
