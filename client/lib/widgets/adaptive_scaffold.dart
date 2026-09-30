import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import 'app_logo.dart';
import 'user_avatar.dart';

class AdaptiveScaffoldDestination {
  final String label;
  final Icon icon;
  final Icon selectedIcon;

  const AdaptiveScaffoldDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}

class AdaptiveScaffold extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final List<AdaptiveScaffoldDestination> destinations;

  const AdaptiveScaffold({
    super.key,
    required this.navigationShell,
    required this.destinations,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppConstants.tabletBreakpoint;

    final authState = ref.watch(authProvider);
    final isGuest = authState.isGuest;

    final displayName = authState.user != null
        ? (authState.user!.displayName ??
              authState.user!.email?.split('@').first ??
              'User')
        : 'Guest';

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop)
            _buildSidebar(context, ref, theme, authState, isGuest, displayName),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(
                  context,
                  ref,
                  theme,
                  authState,
                  isGuest,
                  displayName,
                  size.width,
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: child,
                    ),
                    child: navigationShell,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop ? _buildBottomNav(context, theme) : null,
    );
  }

  // ─── AppBar (only logo + profile photo) ──────────────────────────────────
  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AuthState authState,
    bool isGuest,
    String displayName,
    double screenWidth,
  ) {
    final avatarUrl = authState.user?.avatarUrl;

    final isVerySmall = screenWidth < 360;
    final isDesktop = screenWidth >= AppConstants.tabletBreakpoint;
    return AppBar(
      title: isDesktop
          ? null
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const AppLogo(radius: 16, iconSize: 18),
                if (!isVerySmall) ...[
                  const SizedBox(width: 10),
                  Text(
                    AppConstants.appName,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: isGuest
              ? Tooltip(
                  message: 'Log in',
                  child: GestureDetector(
                    onTap: () => context.go('/login'),
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        Icons.account_circle_outlined,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                )
              : Tooltip(
                  message: 'View profile',
                  child: GestureDetector(
                    onTap: () => context.go('/profile'),
                    child: UserAvatar(
                      avatarUrl: avatarUrl,
                      displayName: displayName,
                      radius: 16,
                      fallbackIcon: Icons.account_circle_outlined,
                      iconSize: 20,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // ─── Desktop Sidebar ──────────────────────────────────────────────────────
  Widget _buildSidebar(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    AuthState authState,
    bool isGuest,
    String displayName,
  ) {
    final avatarUrl = authState.user?.avatarUrl;

    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                const AppLogo(radius: 18, iconSize: 20),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    AppConstants.appShortName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 8),

          // Nav Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _sidebarItem(
                  context,
                  theme,
                  'Home',
                  Icons.home_outlined,
                  Icons.home,
                  0,
                ),
                _sidebarItem(
                  context,
                  theme,
                  'Calculator',
                  Icons.calculate_outlined,
                  Icons.calculate,
                  1,
                ),
                _sidebarItem(
                  context,
                  theme,
                  'Learn',
                  Icons.menu_book_outlined,
                  Icons.menu_book,
                  5,
                ),
                _sidebarItem(
                  context,
                  theme,
                  'AI Assistant',
                  Icons.smart_toy_outlined,
                  Icons.smart_toy,
                  2,
                ),
                _sidebarItem(
                  context,
                  theme,
                  'Community',
                  Icons.groups_outlined,
                  Icons.groups,
                  3,
                ),
                _sidebarItem(
                  context,
                  theme,
                  'VAT Items',
                  Icons.receipt_long_outlined,
                  Icons.receipt_long,
                  6,
                ),
                _sidebarItem(
                  context,
                  theme,
                  'Profile',
                  Icons.person_outlined,
                  Icons.person,
                  4,
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // User section at bottom
          Container(
            padding: const EdgeInsets.all(16),
            child: Tooltip(
              message: 'View profile',
              child: GestureDetector(
                onTap: () => context.go('/profile'),
                child: Row(
                  children: [
                    UserAvatar(
                      avatarUrl: avatarUrl,
                      displayName: displayName,
                      radius: 18,
                      fallbackIcon: Icons.account_circle_outlined,
                      iconSize: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            displayName,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            isGuest ? 'Guest Mode' : 'View Profile',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
    BuildContext context,
    ThemeData theme,
    String label,
    IconData icon,
    IconData selectedIcon,
    int index,
  ) {
    final isActive = navigationShell.currentIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Material(
        color: isActive
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: () => navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          ),
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Icon(
                  isActive ? selectedIcon : icon,
                  size: 22,
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                      color: isActive
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (isActive)
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Salomon Bottom Navigation Bar (5 Core Destinations) ──────────────────
  Widget _buildBottomNav(BuildContext context, ThemeData theme) {
    final currentIndex = navigationShell.currentIndex;
    final salomonIndex = currentIndex >= 0 && currentIndex <= 4 ? currentIndex : 0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SalomonBottomBar(
            currentIndex: salomonIndex,
            onTap: (index) {
              navigationShell.goBranch(
                index,
                initialLocation: index == navigationShell.currentIndex,
              );
            },
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                title: const Text('Home'),
                selectedColor: theme.colorScheme.primary,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.calculate_outlined),
                activeIcon: const Icon(Icons.calculate),
                title: const Text('Calculator'),
                selectedColor: theme.colorScheme.primary,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.smart_toy_outlined),
                activeIcon: const Icon(Icons.smart_toy),
                title: const Text('Assistant'),
                selectedColor: theme.colorScheme.secondary,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.groups_outlined),
                activeIcon: const Icon(Icons.groups),
                title: const Text('Community'),
                selectedColor: theme.colorScheme.tertiary,
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                title: const Text('Profile'),
                selectedColor: theme.colorScheme.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
