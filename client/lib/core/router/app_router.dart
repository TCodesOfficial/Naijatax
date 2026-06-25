import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/adaptive_scaffold.dart';
import '../constants/app_constants.dart';

// Screens imports
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/landing/web_landing_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/assessment_form_screen.dart';
import '../../screens/ai_chat/chat_screen.dart';
import '../../screens/forum/topic_list_screen.dart';
import '../../screens/forum/topic_detail_screen.dart';
import '../../screens/quiz/quiz_play_screen.dart';
import '../../screens/quiz/quiz_history_screen.dart';
import '../../screens/educational/tax_education_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/support/support_center_screen.dart';
import '../../screens/documents/documents_vault_screen.dart';
import '../../screens/profile/verify_account_screen.dart';
import '../../screens/calculator/nta_brackets_screen.dart';
import '../../screens/news/latest_news_screen.dart';
import '../../screens/dashboard/analytics_history_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final hasOnboarded = prefs.getBool(AppConstants.onboardedKey) ?? false;
      final location = state.matchedLocation;
      final isLoggingIn = location == '/login' || location == '/register';

      if (!hasOnboarded && location != '/onboarding') {
        return '/onboarding';
      }

      if (authState.status != AuthStatus.unauthenticated && isLoggingIn) {
        return '/dashboard';
      }

      // Guard protected routes for guests/unauthenticated users
      final isProtected = location.startsWith('/chat') ||
          location.startsWith('/profile/documents') ||
          location.startsWith('/profile/verify');
      if (isProtected && authState.isGuest) {
        return '/login';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => const WebLandingScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Adaptive Shell with 5 bottom nav tabs
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
            ],
          );
        },
        branches: [
          // ─── Branch 0: Home ──────────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
                routes: [
                  GoRoute(
                    path: 'education',
                    builder: (context, state) => const TaxEducationScreen(),
                  ),
                  GoRoute(
                    path: 'news',
                    builder: (context, state) => const LatestNewsScreen(),
                  ),
                  GoRoute(
                    path: 'analytics',
                    builder: (context, state) => const AnalyticsHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // ─── Branch 1: Calculator ────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calculator',
                builder: (context, state) => const AssessmentFormScreen(),
                routes: [
                  GoRoute(
                    path: 'nta-brackets',
                    builder: (context, state) => const NtaBracketsScreen(),
                  ),
                ],
              ),
            ],
          ),

          // ─── Branch 2: AI Assistant ──────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),

          // ─── Branch 3: Community ─────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/forum',
                builder: (context, state) => const TopicListScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return TopicDetailScreen(topicId: id);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: '/quiz',
                builder: (context, state) => const QuizPlayScreen(),
                routes: [
                  GoRoute(
                    path: 'history',
                    builder: (context, state) => const QuizHistoryScreen(),
                  ),
                ],
              ),
            ],
          ),

          // ─── Branch 4: Profile ───────────────────────────────────────────
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
                routes: [
                  GoRoute(
                    path: 'support',
                    builder: (context, state) => const SupportCenterScreen(),
                  ),
                  GoRoute(
                    path: 'documents',
                    builder: (context, state) => const DocumentsVaultScreen(),
                  ),
                  GoRoute(
                    path: 'verify',
                    builder: (context, state) => const VerifyAccountScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
