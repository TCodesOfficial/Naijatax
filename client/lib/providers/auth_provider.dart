import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/dummy/dev_data.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';
import '../services/api_service.dart';

enum AuthStatus { loading, authenticated, guest, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;
  final bool needsOtpVerification;
  final String? pendingPhone;

  const AuthState({
    required this.status,
    this.user,
    this.error,
    this.needsOtpVerification = false,
    this.pendingPhone,
  });

  bool get isGuest => status == AuthStatus.guest;
  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends Notifier<AuthState> {
  SupabaseClient get _client => Supabase.instance.client;

  @override
  AuthState build() {
    try {
      final session = _client.auth.currentSession;
      if (session != null) {
        _listenToAuthChanges();
        final user = session.user;
        return AuthState(
          status: AuthStatus.authenticated,
          user: UserModel(
            id: user.id,
            email: user.email,
            phone: user.phone,
            displayName: user.userMetadata?['display_name'] as String?,
            avatarUrl: user.userMetadata?['avatar_url'] as String?,
            role: 'USER',
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (_) {
      // Supabase not initialized — running in offline/demo mode
      return const AuthState(status: AuthStatus.unauthenticated);
    }
    _listenToAuthChanges();
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  void _listenToAuthChanges() {
    try {
      _client.auth.onAuthStateChange.listen((data) {
        final event = data.event;
        final session = data.session;
        if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) {
          if (session != null) {
            final user = session.user;
            state = AuthState(
              status: AuthStatus.authenticated,
              user: UserModel(
                id: user.id,
                email: user.email,
                phone: user.phone,
                displayName: user.userMetadata?['display_name'] as String?,
                avatarUrl: user.userMetadata?['avatar_url'] as String?,
                role: 'USER',
                createdAt: DateTime.now(),
              ),
            );
          }
        } else if (event == AuthChangeEvent.signedOut) {
          state = const AuthState(status: AuthStatus.unauthenticated);
        }
      });
    } catch (_) {
      // Supabase not initialized
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final res = await _client.auth.signInWithPassword(email: email, password: password);
      final u = res.user;
      if (u == null) {
        state = const AuthState(status: AuthStatus.unauthenticated, error: 'Sign in failed. Please try again.');
        return;
      }
      state = AuthState(
        status: AuthStatus.authenticated,
        user: UserModel(
          id: u.id,
          email: u.email,
          phone: u.phone,
          displayName: u.userMetadata?['display_name'] as String?,
          avatarUrl: u.userMetadata?['avatar_url'] as String?,
          role: 'USER',
          createdAt: DateTime.now(),
        ),
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    } catch (_) {
      // Supabase not initialized — use dev data
      state = AuthState(status: AuthStatus.authenticated, user: DevData.user);
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final u = res.user;
      if (u == null) {
        state = AuthState(status: AuthStatus.unauthenticated, error: 'Check your email to confirm your account.');
        return;
      }
      state = AuthState(
        status: AuthStatus.authenticated,
        user: UserModel(
          id: u.id,
          email: u.email,
          phone: u.phone,
          displayName: u.userMetadata?['display_name'] as String?,
          avatarUrl: u.userMetadata?['avatar_url'] as String?,
          role: 'USER',
          createdAt: DateTime.now(),
        ),
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    } catch (_) {
      // Supabase not initialized — use dev data
      state = AuthState(status: AuthStatus.authenticated, user: DevData.user);
    }
  }

  // ─── Phone Authentication ───────────────────────────────────────────────

  Future<void> signInWithPhone(String phone) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _client.auth.signInWithOtp(phone: phone);
      state = AuthState(
        status: AuthStatus.unauthenticated,
        needsOtpVerification: true,
        pendingPhone: phone,
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    } catch (_) {
      // Supabase not initialized — use dev data
      state = AuthState(status: AuthStatus.authenticated, user: DevData.user);
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final res = await _client.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      final u = res.user;
      if (u == null) {
        state = const AuthState(status: AuthStatus.unauthenticated, error: 'Invalid OTP. Please try again.');
        return;
      }
      state = AuthState(
        status: AuthStatus.authenticated,
        user: UserModel(
          id: u.id,
          email: u.email,
          phone: u.phone,
          displayName: u.userMetadata?['display_name'] as String?,
          avatarUrl: u.userMetadata?['avatar_url'] as String?,
          role: 'USER',
          createdAt: DateTime.now(),
        ),
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    } catch (_) {
      state = AuthState(status: AuthStatus.authenticated, user: DevData.user);
    }
  }

  Future<void> signUpWithPhone(String phone, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _client.auth.signUp(
        phone: phone,
        password: password,
      );
      state = AuthState(
        status: AuthStatus.unauthenticated,
        needsOtpVerification: true,
        pendingPhone: phone,
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    } catch (_) {
      state = AuthState(status: AuthStatus.authenticated, user: DevData.user);
    }
  }

  // ─── OAuth ──────────────────────────────────────────────────────────────

  Future<void> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(OAuthProvider.google,
        redirectTo: 'com.naijatax://login-callback');
  }

  Future<void> signInWithApple() async {
    await _client.auth.signInWithOAuth(OAuthProvider.apple,
        redirectTo: 'com.naijatax://login-callback');
  }

  void continueAsGuest() {
    state = const AuthState(status: AuthStatus.guest);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
    // Clear local cache
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.onboardedKey);
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> updateAvatar(String avatarUrl) async {
    final current = state.user;
    if (current == null) return;
    state = AuthState(
      status: state.status,
      user: UserModel(
        id: current.id,
        email: current.email,
        phone: current.phone,
        displayName: current.displayName,
        role: current.role,
        avatarUrl: avatarUrl,
        createdAt: current.createdAt,
      ),
    );
    try {
      await ApiService.instance.updateAvatar(avatarUrl);
      await _client.auth.updateUser(UserAttributes(data: {'avatar_url': avatarUrl}));
    } catch (_) {
      // Server/metadata persist failed — local state already updated
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
