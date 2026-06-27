import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/auth_provider.dart';
import '../../screens/ai_chat/chat_screen.dart';
import '../../screens/assessment_form_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/calculator/nta_brackets_screen.dart';
import '../../screens/dashboard/analytics_history_screen.dart';
import '../../screens/dashboard_screen.dart';
import '../../screens/documents/documents_vault_screen.dart';
import '../../screens/educational/tax_education_screen.dart';
import '../../screens/forum/topic_detail_screen.dart';
import '../../screens/forum/topic_list_screen.dart';
import '../../screens/landing/web_landing_screen.dart';
import '../../screens/landing/mobile_landing_screen.dart';
import '../../screens/news/latest_news_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/profile/verify_account_screen.dart';
import '../../screens/quiz/quiz_history_screen.dart';
import '../../screens/quiz/quiz_play_screen.dart';
import '../../screens/support/support_center_screen.dart';
import '../../widgets/adaptive_scaffold.dart';
import '../constants/app_constants.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

bool get _isMobile {
  if (kIsWeb) return false;
  return Platform.isAndroid || Platform.isIOS;
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final hasOnboarded = prefs.getBool(AppConstants.onboardedKey) ?? false;
      final location = state.matchedLocation;
      final isAuthRoute = location == '/login' || location == '/register';
      final isOnboarding = location == '/onboarding';
      final isLanding = location == '/landing';

      // ── Mobile platforms (Android, iOS, Mac, Windows) ────────────────
      // If user has onboarded or is authenticated, skip landing + onboarding
      if (_isMobile) {
        if ((hasOnboarded || authState.isAuthenticated) && (isLanding || isOnboarding)) {
          return '/dashboard';
        }
      }

      // ── Web ─────────────────────────────────────────────────────────
      // If authenticated and hasn't onboarded, force onboarding
      if (authState.isAuthenticated && !hasOnboarded && !isOnboarding) {
        return '/onboarding';
      }

      // If authenticated and trying to visit auth pages, go to dashboard
      if (authState.isAuthenticated && isAuthRoute) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/landing',
        builder: (context, state) => _isMobile
            ? const MobileLandingScreen()
            : const WebLandingScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
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

          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/chat',
                builder: (context, state) => const ChatScreen(),
              ),
            ],
          ),

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
