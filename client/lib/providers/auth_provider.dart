import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

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
    final session = _client.auth.currentSession;
    if (session != null) {
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
    return const AuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> signInWithEmail(String email, String password) async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      final res = await _client.auth.signInWithPassword(email: email, password: password);
      final u = res.user!;
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
      final u = res.user!;
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
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
