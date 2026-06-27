import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';
import 'app_logo.dart';

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
        ? (authState.user!.displayName ?? authState.user!.email?.split('@').first ?? 'User')
        : 'Guest';

    return Scaffold(
      body: Row(
        children: [
          if (isDesktop) _buildSidebar(context, ref, theme, authState, isGuest, displayName),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(context, ref, theme, authState, isGuest, displayName, size.width),
                Expanded(child: navigationShell),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: !isDesktop
          ? _buildBottomNav(context, theme)
          : null,
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
                  Flexible(
                    child: Text(
                      AppConstants.appName,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: isGuest
              ? GestureDetector(
                  onTap: () => context.go('/login'),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.person,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () => context.go('/profile'),
                  child: CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage: authState.user?.avatarUrl != null
                        ? CachedNetworkImageProvider(authState.user!.avatarUrl!)
                        : null,
                    child: authState.user?.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: 18,
                            color: theme.colorScheme.primary,
                          )
                        : null,
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
                _sidebarItem(context, theme, 'Home', Icons.home_outlined, Icons.home, 0),
                _sidebarItem(context, theme, 'Calculator', Icons.calculate_outlined, Icons.calculate, 1),
                _sidebarItem(context, theme, 'AI Assistant', Icons.smart_toy_outlined, Icons.smart_toy, 2),
                _sidebarItem(context, theme, 'Community', Icons.groups_outlined, Icons.groups, 3),
                _sidebarItem(context, theme, 'Profile', Icons.person_outlined, Icons.person, 4),
              ],
            ),
          ),

          const Divider(height: 1),

          // User section at bottom
          Container(
            padding: const EdgeInsets.all(16),
            child: GestureDetector(
              onTap: () => context.go('/profile'),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    backgroundImage: authState.user?.avatarUrl != null
                        ? CachedNetworkImageProvider(authState.user!.avatarUrl!)
                        : null,
                    child: authState.user?.avatarUrl == null
                        ? Icon(
                            Icons.person,
                            size: 18,
                            color: theme.colorScheme.primary,
                          )
                        : null,
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
          onTap: () => _onTap(context, index),
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

  // ─── Enhanced Bottom Navigation Bar (mobile) ──────────────────────────────
  Widget _buildBottomNav(BuildContext context, ThemeData theme) {
    return Container(
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: GNav(
          selectedIndex: navigationShell.currentIndex,
          onTabChange: (index) => _onTap(context, index),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          tabBorderRadius: 20,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          backgroundColor: Colors.transparent,
          activeColor: theme.colorScheme.onSecondaryContainer,
          color: theme.colorScheme.onSurfaceVariant,
          tabBackgroundColor: theme.colorScheme.secondaryContainer,
          iconSize: 24,
          textStyle: TextStyle(
            fontSize: 12,
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
              text: 'Assistant',
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
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
