import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    final userEmail = authState.user?.email ?? 'Guest User';
    final isGuest = authState.isGuest;

    // Get current screen title based on selected index
    final String currentTitle = destinations[navigationShell.currentIndex].label;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.account_balance, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              currentTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: isGuest
                ? TextButton.icon(
                    onPressed: () {
                      ref.read(authProvider.notifier).signOut();
                    },
                    icon: const Icon(Icons.login),
                    label: const Text('Log In'),
                  )
                : Row(
                    children: [
                      Text(
                        userEmail.split('@').first,
                        style: theme.textTheme.titleSmall,
                      ),
                      const SizedBox(width: 8),
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          userEmail[0].toUpperCase(),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
      body: isMobile
          ? navigationShell
          : Row(
              children: [
                NavigationRail(
                  selectedIndex: navigationShell.currentIndex,
                  onDestinationSelected: (index) => _onTap(context, index),
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: theme.colorScheme.surfaceContainerLow,
                  leading: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: theme.colorScheme.primary,
                          child: const Icon(Icons.account_balance, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'NaijaTax',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 24.0),
                        child: IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            ref.read(authProvider.notifier).signOut();
                          },
                        ),
                      ),
                    ),
                  ),
                  destinations: destinations
                      .map(
                        (d) => NavigationRailDestination(
                          icon: d.icon,
                          selectedIcon: d.selectedIcon,
                          label: Text(d.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            ),
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              items: destinations
                  .map(
                    (d) => BottomNavigationBarItem(
                      icon: d.icon,
                      activeIcon: d.selectedIcon,
                      label: d.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
