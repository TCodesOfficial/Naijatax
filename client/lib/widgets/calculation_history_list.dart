import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../models/tax_profile.dart';

/// Shared empty state shown when there are no calculations yet.
class EmptyHistoryState extends StatelessWidget {
  final String title;
  final String message;
  final bool showAction;

  const EmptyHistoryState({
    super.key,
    this.title = 'No calculations yet',
    this.message = 'Run your first assessment and it will appear here.',
    this.showAction = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.history_rounded,
                size: 36,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (showAction) ...[
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => context.go('/calculator'),
                icon: const Icon(Icons.calculate_outlined, size: 18),
                label: const Text('Start calculating'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// List of saved calculations. Tap a row to open its detail screen.
class CalculationHistoryList extends StatelessWidget {
  final List<TaxProfile> items;
  final bool shrinkWrap;

  const CalculationHistoryList({
    super.key,
    required this.items,
    this.shrinkWrap = true,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const EmptyHistoryState();

    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, i) => CalculationHistoryTile(profile: items[i]),
    );
  }
}

class CalculationHistoryTile extends StatelessWidget {
  final TaxProfile profile;

  const CalculationHistoryTile({super.key, required this.profile});

  String get _dateLabel {
    final createdAt = profile.createdAt;
    if (createdAt == null) return 'Saved on this device';
    return DateFormat('d MMM yyyy · h:mm a').format(createdAt.toLocal());
  }

  String get _typeLabel {
    final first = profile.breakdown.isNotEmpty ? profile.breakdown.first.bracket : '';
    if (first.startsWith('Flat')) return first;
    if (profile.isExempt) return 'Exempt';
    return 'Annual PAYE';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final naira = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 0);

    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          '/calculator/history/${profile.id ?? profile.createdAt?.millisecondsSinceEpoch ?? 0}',
          extra: profile,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
                child: Icon(
                  profile.isExempt
                      ? Icons.shield_outlined
                      : Icons.calculate_outlined,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${naira.format(profile.annualGross)}/yr income',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$_dateLabel · $_typeLabel',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    profile.isExempt ? 'No tax' : naira.format(profile.computedTax),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: profile.isExempt
                          ? Colors.green
                          : theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Net ${naira.format(profile.netIncome)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
