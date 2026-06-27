import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                    context.go('/login');
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
