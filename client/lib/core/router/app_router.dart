import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import '../../services/storage_service.dart';
import '../../screens/ai_chat/chat_screen.dart';
import '../../screens/calculator/assessment_form_screen.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/reset_password_screen.dart';
import '../../screens/calculator/calculation_detail_screen.dart';
import '../../screens/calculator/calculation_history_screen.dart';
import '../../screens/calculator/nta_brackets_screen.dart';
import '../../screens/dashboard/analytics_history_screen.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/documents/documents_vault_screen.dart';
import '../../screens/learn/tax_education_screen.dart';
import '../../screens/forum/topic_detail_screen.dart';
import '../../screens/forum/topic_list_screen.dart';
import '../../screens/landing/mobile_landing_screen.dart';
import '../../screens/landing/web_landing_screen.dart';
import '../../screens/learn/tax_reform_screen.dart';
import '../../screens/news/latest_news_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/profile/personal_details_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/verify_account_screen.dart';
import '../../screens/quiz/quiz_history_screen.dart';
import '../../screens/quiz/quiz_play_screen.dart';
import '../../screens/support/support_center_screen.dart';
import '../../screens/vat/vat_items_screen.dart';
import '../../widgets/adaptive_scaffold.dart';
import '../../models/tax_profile.dart';
import 'transitions.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

bool get _isNativePlatform => !kIsWeb;

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.read(authProvider.notifier);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    refreshListenable: authNotifier.refreshNotifier,
    redirect: (context, state) async {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;
      final isAuthenticatedLike =
          authState.isAuthenticated || authState.isGuest;
      final isGuest = authState.isGuest;

      // authState.user is null when signed out, so fall back to the persisted
      // flag — otherwise returning-user rules could never fire (RULE 4 was dead).
      final hasOnboarded = authState.user?.onboarded ??
          (StorageService.getSetting<bool>('onboarded') ?? false);

      // Password-reset screens are reachable while signed out, and must NOT
      // bounce mid-flow when verifying the code logs the user in.
      final isPasswordReset = location == '/forgot-password' ||
          location == '/reset-password';
      final isAuthRoute = location == '/login' ||
          location == '/register' ||
          isPasswordReset;
      final isOnboarding = location == '/onboarding';
      final isLanding = location == '/landing';

      // ── LOADING: Don't redirect while auth state is resolving ──────────
      if (authState.status == AuthStatus.loading) return null;

      // ── RULE 1: Authenticated/guest users on auth routes or landing → go straight to dashboard ─────
      if (isAuthenticatedLike &&
          (isAuthRoute || isLanding) &&
          !isPasswordReset) {
        return '/dashboard';
      }

      // ── RULE 1b: Signed-in users must pass through onboarding ──────────
      // Without this, landing/login redirects dropped fresh sign-ups straight
      // onto the dashboard and onboarding was skipped entirely.
      if (authState.isAuthenticated &&
          !hasOnboarded &&
          !isOnboarding &&
          !isPasswordReset) {
        return '/onboarding';
      }

      // ── RULE 2: Already completed onboarding or guest → skip onboarding ─
      if ((hasOnboarded || isGuest) && isOnboarding) {
        return '/dashboard';
      }

      // ── RULE 4: Native returning users → skip landing to login ──────
      // If the user onboarded before but the session expired, go straight to login
      if (_isNativePlatform &&
          !isAuthenticatedLike &&
          hasOnboarded &&
          isLanding) {
        return '/login';
      }

      // ── RULE 5: Unauthenticated on protected route → login/landing ──
      // After signOut or session expiry, redirect away from protected screens
      if (!isAuthenticatedLike && !isOnboarding && !isAuthRoute && !isLanding) {
        return _isNativePlatform ? '/login' : '/landing';
      }

      return null;
    },
    errorBuilder: (context, state) {
      // Unknown routes render a real 404 page instead of an exception screen.
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.explore_off_outlined,
                    size: 64, color: Theme.of(context).colorScheme.outline),
                const SizedBox(height: 16),
                Text('Page not found',
                    style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'No screen exists at ${state.uri.path}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    final auth = ref.read(authProvider);
                    context.go(auth.isAuthenticated || auth.isGuest
                        ? '/dashboard'
                        : '/landing');
                  },
                  child: const Text('Go Home'),
                ),
              ],
            ),
          ),
        ),
      );
    },
    routes: [
      GoRoute(
        path: '/landing',
        pageBuilder: (context, state) => appTransitionPage(
          state: state,
          child: _isNativePlatform
              ? const MobileLandingScreen()
              : const WebLandingScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) => appTransitionPage(
          state: state,
          child: const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => appTransitionPage(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        pageBuilder: (context, state) => appTransitionPage(
          state: state,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) => appTransitionPage(
          state: state,
          child: const ForgotPasswordScreen(),
        ),
      ),
      GoRoute(
        path: '/reset-password',
        pageBuilder: (context, state) => appTransitionPage(
          state: state,
          child: ResetPasswordScreen(
            email: state.extra is String ? state.extra as String? : null,
          ),
        ),
      ),

      // Adaptive Shell with 6 branches (5 bottom nav + 1 desktop-only)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveScaffold(
            navigationShell: navigationShell,
            destinations: const [
              AdaptiveScaffoldDestination(
                label: 'Home',
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
              ),
              AdaptiveScaffoldDestination(
                label: 'Calculator',
                icon: Icon(Icons.calculate_outlined),
                selectedIcon: Icon(Icons.calculate),
              ),
              AdaptiveScaffoldDestination(
                label: 'AI Assistant',
                icon: Icon(Icons.smart_toy_outlined),
                selectedIcon: Icon(Icons.smart_toy),
              ),
              AdaptiveScaffoldDestination(
                label: 'Community',
                icon: Icon(Icons.groups_outlined),
                selectedIcon: Icon(Icons.groups),
              ),
              AdaptiveScaffoldDestination(
                label: 'Profile',
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
              ),
              AdaptiveScaffoldDestination(
                label: 'Learn',
                icon: Icon(Icons.menu_book_outlined),
                selectedIcon: Icon(Icons.menu_book),
              ),
              AdaptiveScaffoldDestination(
                label: 'VAT Items',
                icon: Icon(Icons.receipt_long_outlined),
                selectedIcon: Icon(Icons.receipt_long),
              ),
            ],
          );
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'education',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const TaxEducationScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'news',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const LatestNewsScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'analytics',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const AnalyticsHistoryScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Calculator
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calculator',
                builder: (context, state) => const AssessmentFormScreen(),
                routes: [
                  GoRoute(
                    path: 'nta-brackets',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const NtaBracketsScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'history',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const CalculationHistoryScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path: ':id',
                        pageBuilder: (context, state) => appTransitionPage(
                          state: state,
                          child: CalculationDetailScreen(
                            profile: state.extra is TaxProfile
                                ? state.extra as TaxProfile
                                : null,
                            profileId: state.pathParameters['id'],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Branch 2: AI Assistant
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),

          // Branch 3: Community (Forum only)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/forum',
                builder: (context, state) => const TopicListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: TopicDetailScreen(
                        topicId: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Branch 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'support',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const SupportCenterScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'documents',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const DocumentsVaultScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'verify',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const VerifyAccountScreen(),
                    ),
                  ),
                  GoRoute(
                    path: 'personal-details',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const PersonalDetailsScreen(),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Branch 5: Learn
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/learn',
                builder: (context, state) => const TaxReformScreen(),
                routes: [
                  GoRoute(
                    path: 'quiz',
                    pageBuilder: (context, state) => appTransitionPage(
                      state: state,
                      child: const QuizPlayScreen(),
                    ),
                    routes: [
                      GoRoute(
                        path: 'history',
                        pageBuilder: (context, state) => appTransitionPage(
                          state: state,
                          child: const QuizHistoryScreen(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Branch 6: VAT Items
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vat-items',
                builder: (context, state) => const VatItemsScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
