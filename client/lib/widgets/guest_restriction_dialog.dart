import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';

/// Takes a guest to the landing page so they can sign up or log in.
/// Ends the guest session first, otherwise the router sends guests on the
/// landing/login screens straight back to the dashboard.
Future<void> goToSignIn(BuildContext context) async {
  final router = GoRouter.of(context);
  final auth = ProviderScope.containerOf(context, listen: false)
      .read(authProvider.notifier);
  await auth.leaveGuestMode();
  router.go('/landing');
}

void showGuestRestrictionDialog(BuildContext context) {
  final theme = Theme.of(context);
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_outline, size: 36, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            'Account Required',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            'This feature requires an account. Please log in or sign up to continue.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    goToSignIn(context);
                  },
                  child: const Text('Log In'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
