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
import '../../screens/vat/vat_guide_screen.dart';
import '../../screens/ai_chat/chat_screen.dart';
import '../../screens/forum/topic_list_screen.dart';
import '../../screens/forum/topic_detail_screen.dart';
import '../../screens/quiz/quiz_play_screen.dart';
import '../../screens/quiz/quiz_history_screen.dart';
import '../../screens/educational/tax_education_screen.dart';
import '../../screens/profile/profile_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/landing',
    redirect: (context, state) async {
      final prefs = await SharedPreferences.getInstance();
      final hasOnboarded = prefs.getBool(AppConstants.onboardedKey) ?? false;
      final isLoggingIn = state.matchedLocation == '/login' || state.matchedLocation == '/register';

      if (!hasOnboarded && state.matchedLocation != '/onboarding') {
        return '/onboarding';
      }

      // If already logged in / guest, redirect from login/register to dashboard
      if (authState.status != AuthStatus.unauthenticated && isLoggingIn) {
        return '/dashboard';
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

      // Stateful shell route for bottom bar / sidebar adaptive layout
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdaptiveScaffold(
            navigationShell: navigationShell,
            destinations: const [
              AdaptiveScaffoldDestination(
                label: 'Dashboard',
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
              ),
              AdaptiveScaffoldDestination(
                label: 'Calculator',
                icon: Icon(Icons.calculate_outlined),
                selectedIcon: Icon(Icons.calculate),
              ),
              AdaptiveScaffoldDestination(
                label: 'VAT Guide',
                icon: Icon(Icons.search),
                selectedIcon: Icon(Icons.find_in_page),
              ),
              AdaptiveScaffoldDestination(
                label: 'AI Helper',
                icon: Icon(Icons.psychology_outlined),
                selectedIcon: Icon(Icons.psychology),
              ),
              AdaptiveScaffoldDestination(
                label: 'Forum',
                icon: Icon(Icons.forum_outlined),
                selectedIcon: Icon(Icons.forum),
              ),
              AdaptiveScaffoldDestination(
                label: 'Quiz',
                icon: Icon(Icons.quiz_outlined),
                selectedIcon: Icon(Icons.quiz),
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
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/calculator',
                builder: (context, state) => const AssessmentFormScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vat',
                builder: (context, state) => const VatGuideScreen(),
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
            ],
          ),
          StatefulShellBranch(
            routes: [
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
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
