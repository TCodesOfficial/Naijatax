import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

enum AuthStatus { loading, authenticated, guest, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final String? error;

  const AuthState({required this.status, this.user, this.error});

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
        return AuthState(
          status: AuthStatus.authenticated,
          user: UserModel(
            id: session.user.id,
            email: session.user.email ?? '',
            role: 'USER',
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (_) {
      // Supabase not initialized (demo/offline mode)
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
            state = AuthState(
              status: AuthStatus.authenticated,
              user: UserModel(
                id: session.user.id,
                email: session.user.email ?? '',
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
        user: UserModel(id: u.id, email: u.email ?? '', role: 'USER', createdAt: DateTime.now()),
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      final u = res.user;
      if (u == null) {
        state = const AuthState(status: AuthStatus.unauthenticated, error: 'Check your email to confirm your account.');
        return;
      }
      state = AuthState(
        status: AuthStatus.authenticated,
        user: UserModel(id: u.id, email: u.email ?? '', role: 'USER', createdAt: DateTime.now()),
      );
    } on AuthException catch (e) {
      state = AuthState(status: AuthStatus.unauthenticated, error: e.message);
    }
  }

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

  void updateAvatar(String avatarUrl) {
    final current = state.user;
    if (current == null) return;
    state = AuthState(
      status: state.status,
      user: UserModel(
        id: current.id,
        email: current.email,
        role: current.role,
        avatarUrl: avatarUrl,
        createdAt: current.createdAt,
      ),
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
