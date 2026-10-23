import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_colors.dart';
import '../../core/utils/app_formatter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tax_provider.dart';
import '../../services/pdf_service.dart';
import '../../widgets/calculation_history_list.dart';
import '../../widgets/tax_charts_widget.dart';
import 'amounts_form.dart';
import 'percentage_form.dart';

class AssessmentFormScreen extends ConsumerStatefulWidget {
  const AssessmentFormScreen({super.key});

  @override
  ConsumerState<AssessmentFormScreen> createState() =>
      _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends ConsumerState<AssessmentFormScreen> {
  int _mode = 0; // 0 = Amounts, 1 = Percentages

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(taxProvider.notifier).fetchHistory());
  }

  void _calculateAmounts({
    required double monthlyIncome,
    required double rentPaid,
    required double pensionRate,
    required double turnover,
    required double assets,
  }) {
    ref.read(taxProvider.notifier).calculate(
          monthlyIncome: monthlyIncome,
          rentPaid: rentPaid,
          pensionRate: pensionRate,
          turnover: turnover,
          assets: assets,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taxState = ref.watch(taxProvider);
    final size = MediaQuery.of(context).size;
    final hasBottomNav = size.width < AppConstants.tabletBreakpoint;
    final history = taxState.history.take(5).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        hasBottomNav ? 92 : 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Mode switcher ────────────────────────────────────────────
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(
                value: 0,
                icon: Icon(Icons.payments_outlined),
                label: Text('Amounts'),
              ),
              ButtonSegment(
                value: 1,
                icon: Icon(Icons.percent_rounded),
                label: Text('Percentages'),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => setState(() => _mode = s.first),
            showSelectedIcon: false,
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              backgroundColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surfaceContainerLow),
              foregroundColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurfaceVariant),
              textStyle: WidgetStatePropertyAll(
                theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ─── Forms (state-safe switch with slide/fade) ────────────────
          _ModePane(
            mode: _mode,
            children: [
              AmountsForm(
                isLoading: taxState.status == TaxStatus.loading,
                onCalculate: _calculateAmounts,
              ),
              const PercentageForm(),
            ],
          ),
          const SizedBox(height: 20),

          // ─── Results ──────────────────────────────────────────────────
          if (taxState.status == TaxStatus.error)
            Card(
              color: theme.colorScheme.errorContainer,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  taxState.error ?? 'Error computing tax.',
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
            ),

          if (taxState.profile != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Assessment Summary',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.picture_as_pdf),
                          tooltip: 'Export Report as PDF',
                          onPressed: () => PdfService.exportTaxReport(
                            taxState.profile!,
                            userName: ref.read(authProvider).user?.displayName,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _resultRow('Annual Gross Income',
                        AppFormatter.nairaDecimal(taxState.profile!.annualGross)),
                    _resultRow('Pension Deductible',
                        AppFormatter.nairaDecimal(taxState.profile!.pensionDeduction)),
                    _resultRow('Rent Relief Portion',
                        AppFormatter.nairaDecimal(taxState.profile!.rentRelief)),
                    const Divider(height: 24),
                    _resultRow(
                      'Computed Monthly Tax (PAYE)',
                      AppFormatter.nairaDecimal(taxState.profile!.computedTax / 12),
                      valueColor: theme.colorScheme.error,
                      bold: true,
                    ),
                    _resultRow(
                      'Computed Annual Tax (PAYE)',
                      AppFormatter.nairaDecimal(taxState.profile!.computedTax),
                      valueColor: theme.colorScheme.error,
                      bold: true,
                    ),
                    _resultRow(
                      'Annual Net Take-Home',
                      AppFormatter.nairaDecimal(taxState.profile!.netIncome),
                      valueColor: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkSuccess
                          : AppColors.success,
                      bold: true,
                    ),
                    _resultRow(
                      'Annual Savings vs. Old Act',
                      AppFormatter.nairaDecimal(taxState.profile!.savings),
                      valueColor: theme.colorScheme.secondary,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TaxChartsWidget(profile: taxState.profile!),
            const SizedBox(height: 20),
          ],

          // ─── Recent calculations ──────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Calculations',
                        style: theme.textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (history.isNotEmpty)
                        TextButton.icon(
                          onPressed: () => context.push('/calculator/history'),
                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                          label: const Text('View all'),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (taxState.historyLoading && history.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else
                    CalculationHistoryList(items: history),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _resultRow(String label, String value,
      {Color? valueColor, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
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

/// Keeps both forms alive (typed values preserved) and animates the
/// visible one with a direction-aware slide + fade on mode switch.
class _ModePane extends StatefulWidget {
  final int mode;
  final List<Widget> children;

  const _ModePane({required this.mode, required this.children});

  @override
  State<_ModePane> createState() => _ModePaneState();
}

class _ModePaneState extends State<_ModePane>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  double _direction = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
      value: 1,
    );
  }

  @override
  void didUpdateWidget(covariant _ModePane oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.mode != oldWidget.mode) {
      _direction = widget.mode > oldWidget.mode ? 1 : -1;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    return AnimatedBuilder(
      animation: curved,
      builder: (context, _) {
        return Opacity(
          opacity: curved.value,
          child: Transform.translate(
            offset: Offset(_direction * 24 * (1 - curved.value), 0),
            child: IndexedStack(
              index: widget.mode,
              children: widget.children,
            ),
          ),
        );
      },
    );
  }
}
