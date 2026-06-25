import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

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
    final isMobile = size.width < AppConstants.mobileBreakpoint;

    final authState = ref.watch(authProvider);
    final isGuest = authState.isGuest;
    final displayName = authState.user != null
        ? authState.user!.email.split('@').first
        : 'Guest';

    return Scaffold(
      // ─── AppBar matching Stitch design ────────────────────────────────────
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: theme.colorScheme.primary,
              child: Icon(
                Icons.account_balance,
                color: theme.colorScheme.onPrimary,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'NaijaTax Enlighten',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        // Desktop navigation links (hidden on mobile)
        actions: [
          if (!isMobile) ...[
            _desktopNavLink(context, 'Home', 0, theme),
            _desktopNavLink(context, 'Calculator', 1, theme),
            _desktopNavLink(context, 'AI Assistant', 2, theme),
            _desktopNavLink(context, 'Community', 3, theme),
            const SizedBox(width: 8),
          ],
          // Notification bell
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: theme.colorScheme.primary,
            ),
          ),
          // User avatar or login button
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: isGuest
                ? TextButton.icon(
                    onPressed: () => context.go('/login'),
                    icon: const Icon(Icons.login, size: 18),
                    label: const Text('Log In'),
                  )
                : CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage: authState.user?.avatarUrl != null
                        ? CachedNetworkImageProvider(authState.user!.avatarUrl!)
                        : null,
                    child: authState.user?.avatarUrl == null
                        ? Text(
                            displayName[0].toUpperCase(),
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          )
                        : null,
                  ),
          ),
        ],
      ),

      // ─── Body ────────────────────────────────────────────────────────────
      body: navigationShell,

      // ─── Bottom Navigation Bar (mobile only) using google_nav_bar ──────
      bottomNavigationBar: isMobile
          ? Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                    width: 1,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                child: GNav(
                  selectedIndex: navigationShell.currentIndex,
                  onTabChange: (index) => _onTap(context, index),
                  gap: 4,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  tabBorderRadius: 20,
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                  backgroundColor: Colors.transparent,
                  activeColor: theme.colorScheme.onSecondaryContainer,
                  color: theme.colorScheme.onSurfaceVariant,
                  tabBackgroundColor: theme.colorScheme.secondaryContainer,
                  iconSize: 22,
                  textStyle: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSecondaryContainer,
                  ),
                  tabs: [
                    GButton(
                      icon: navigationShell.currentIndex == 0 ? Icons.home : Icons.home_outlined,
                      text: 'Home',
                    ),
                    GButton(
                      icon: navigationShell.currentIndex == 1 ? Icons.calculate : Icons.calculate_outlined,
                      text: 'Calculator',
                    ),
                    GButton(
                      icon: navigationShell.currentIndex == 2 ? Icons.smart_toy : Icons.smart_toy_outlined,
                      text: 'AI Assistant',
                    ),
                    GButton(
                      icon: navigationShell.currentIndex == 3 ? Icons.groups : Icons.groups_outlined,
                      text: 'Community',
                    ),
                    GButton(
                      icon: navigationShell.currentIndex == 4 ? Icons.person : Icons.person_outline,
                      text: 'Profile',
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _desktopNavLink(BuildContext context, String label, int index, ThemeData theme) {
    final isActive = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 2),
            if (isActive)
              Container(
                height: 2,
                width: 24,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
