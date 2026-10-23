import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/app_formatter.dart';
import '../../models/tax_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tax_provider.dart';
import '../../services/pdf_service.dart';
import '../../widgets/section_card.dart';
import '../../widgets/tax_charts_widget.dart';

/// Full detail of a single saved calculation: summary stats, PAYE rows,
/// charts, bracket breakdown and PDF export.
class CalculationDetailScreen extends ConsumerStatefulWidget {
  final TaxProfile? profile;

  /// Route `:id` fallback — resolved against tax history when [profile]
  /// was not passed via `extra` (deep links, browser refresh).
  final String? profileId;

  const CalculationDetailScreen({super.key, this.profile, this.profileId});

  @override
  ConsumerState<CalculationDetailScreen> createState() =>
      _CalculationDetailScreenState();
}

class _CalculationDetailScreenState
    extends ConsumerState<CalculationDetailScreen> {
  bool _historyRequested = false;

  @override
  void initState() {
    super.initState();
    if (widget.profile == null && widget.profileId != null) {
      _requestHistory();
    }
  }

  void _requestHistory() {
    if (_historyRequested) return;
    _historyRequested = true;
    Future.microtask(() => ref.read(taxProvider.notifier).fetchHistory());
  }

  TaxProfile? _resolve(TaxState state) {
    if (widget.profile != null) return widget.profile;
    final pid = widget.profileId;
    if (pid == null) return null;
    for (final item in state.history) {
      final itemKey =
          item.id?.toString() ?? item.createdAt?.millisecondsSinceEpoch.toString();
      if (itemKey == pid) return item;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final hasBottomNav = size.width < AppConstants.tabletBreakpoint;
    final naira = AppFormatter.nairaDecimal;
    final dateFormat = DateFormat('d MMMM yyyy · h:mm a');
    final taxState = ref.watch(taxProvider);
    final p = _resolve(taxState);
    final userName = ref.read(authProvider).user?.displayName;

    if (p == null) {
      // Deep link: keep loading until the first history fetch settles.
      if (widget.profileId != null &&
          (!_historyRequested || taxState.historyLoading)) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      return SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, hasBottomNav ? 92 : 16),
        child: SectionCard(
          icon: Icons.error_outline_rounded,
          title: 'Assessment not found',
          child: Text(
            'This calculation is no longer available. Run a new assessment '
            'and it will be saved automatically.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        hasBottomNav ? (isMobile ? 16 : 24) + 76 : (isMobile ? 16 : 24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assessment Detail',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.createdAt != null
                          ? dateFormat.format(p.createdAt!.toLocal())
                          : 'Saved on this device',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () => PdfService.exportTaxReport(p, userName: userName),
                tooltip: 'Export as PDF',
                icon: const Icon(Icons.picture_as_pdf_outlined),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ─── Stat grid (2×2) ────────────────────────────────────────────
          _statGrid(theme, naira, p),
          const SizedBox(height: 16),

          // ─── Summary rows ───────────────────────────────────────────────
          SectionCard(
            icon: Icons.receipt_long_outlined,
            title: 'Summary',
            child: Column(
              children: [
                _row(theme, 'Annual Gross Income', naira(p.annualGross)),
                _row(theme, 'Pension Deduction', naira(p.pensionDeduction)),
                _row(theme, 'Rent Relief', naira(p.rentRelief)),
                _row(theme, 'Taxable Income', naira(p.taxableIncome)),
                const Divider(height: 24),
                _row(
                  theme,
                  'Annual Tax (PAYE)',
                  naira(p.computedTax),
                  bold: true,
                  valueColor: theme.colorScheme.error,
                ),
                _row(
                  theme,
                  'Monthly Tax',
                  naira(p.computedTax / 12),
                  bold: true,
                  valueColor: theme.colorScheme.error,
                ),
                _row(
                  theme,
                  'Effective Rate',
                  '${p.effectiveTaxRate.toStringAsFixed(1)}%',
                  bold: true,
                ),
                _row(
                  theme,
                  'Savings vs Old Act',
                  naira(p.savings),
                  bold: true,
                  valueColor: theme.colorScheme.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // ─── Charts ─────────────────────────────────────────────────────
          TaxChartsWidget(profile: p),
          const SizedBox(height: 16),

          // ─── Bracket breakdown ──────────────────────────────────────────
          SectionCard(
            icon: Icons.stacked_bar_chart_outlined,
            title: 'Bracket Breakdown',
            child: Column(
              children: p.breakdown.map((b) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b.bracket,
                              style: theme.textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'On ${naira(b.taxableAmount)}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${(b.rate * 100).toStringAsFixed(b.rate * 100 % 1 == 0 ? 0 : 1)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          naira(b.tax),
                          textAlign: TextAlign.right,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            child: FilledButton.icon(
              onPressed: () => PdfService.exportTaxReport(p, userName: userName),
              icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
              label: const Text('Export full report as PDF'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statGrid(ThemeData theme, String Function(double) naira, TaxProfile p) {
    final cards = [
      (Icons.public_outlined, 'Annual Gross', naira(p.annualGross), theme.colorScheme.primary),
      (Icons.receipt_outlined, 'PAYE Tax', naira(p.computedTax), theme.colorScheme.error),
      (Icons.account_balance_wallet_outlined, 'Take-Home', naira(p.netIncome), Colors.green),
      (Icons.trending_down_rounded, 'Savings', naira(p.savings), theme.colorScheme.secondary),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.9,
      children: cards.map((c) {
        final (icon, label, value, color) = c;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 16, color: color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _row(
    ThemeData theme,
    String label,
    String value, {
    bool bold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(label, style: const TextStyle(fontSize: 14)),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
