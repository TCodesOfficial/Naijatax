import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/theme_colors.dart';
import '../../core/utils/app_formatter.dart';
import '../../models/tax_profile.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tax_provider.dart';
import '../../services/pdf_service.dart';

class AnalyticsHistoryScreen extends ConsumerStatefulWidget {
  const AnalyticsHistoryScreen({super.key});

  @override
  ConsumerState<AnalyticsHistoryScreen> createState() =>
      _AnalyticsHistoryScreenState();
}

class _AnalyticsHistoryScreenState
    extends ConsumerState<AnalyticsHistoryScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(taxProvider.notifier).fetchHistory());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < AppConstants.mobileBreakpoint;
    final taxState = ref.watch(taxProvider);
    final naira = AppFormatter.nairaDecimal;
    final history = taxState.history;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        isMobile ? 16 : 24,
        (isMobile ? 16.0 : 24.0) + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Analytics & Reports',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your historical tax data and income allocations.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    _incomeAllocationCard(theme, taxState),
                    const SizedBox(height: 16),
                    _taxTrendsCard(theme),
                    const SizedBox(height: 16),
                    _historyTable(theme, history, naira, isMobile),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _incomeAllocationCard(theme, taxState)),
                        const SizedBox(width: 20),
                        Expanded(child: _taxTrendsCard(theme)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _historyTable(theme, history, naira, isMobile),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _incomeAllocationCard(ThemeData theme, TaxState taxState) {
    final gross = taxState.profile?.annualGross ?? 0.0;
    final tax = taxState.profile?.computedTax ?? 0.0;
    final pension = taxState.profile?.pensionDeduction ?? 0.0;
    final net = taxState.profile?.netIncome ?? 0.0;

    final hasData = gross > 0;

    final sections = hasData
        ? [
            PieChartSectionData(
              value: net > 0 ? net : 0.01,
              color: theme.colorScheme.primary,
              radius: 50,
              title: '',
            ),
            PieChartSectionData(
              value: tax > 0 ? tax : 0.01,
              color: AppColors.govRed,
              radius: 50,
              title: '',
            ),
            PieChartSectionData(
              value: pension > 0 ? pension : 0.01,
              color: theme.colorScheme.tertiary,
              radius: 50,
              title: '',
            ),
          ]
        : [
            PieChartSectionData(
              value: 1,
              color: theme.colorScheme.outlineVariant,
              radius: 50,
              title: '',
            ),
          ];

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Income Allocation',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Center(
                    child: Text(
                      hasData
                          ? 'Total Gross: ₦${(gross / 1000000).toStringAsFixed(1)}M'
                          : 'Run a calculation to see your allocation',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  if (hasData) ...[
                    const SizedBox(height: 16),
                    _legendItem(theme, 'Net Pay', '${((net / gross) * 100).toStringAsFixed(0)}%', theme.colorScheme.primary),
                    _legendItem(theme, 'Income Tax (PAYE)', '${((tax / gross) * 100).toStringAsFixed(0)}%', AppColors.govRed),
                    _legendItem(theme, 'Pension', '${((pension / gross) * 100).toStringAsFixed(0)}%', theme.colorScheme.tertiary),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(ThemeData theme, String label, String pct, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: theme.textTheme.bodySmall)),
          Text(
            pct,
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _taxTrendsCard(ThemeData theme) {
    // Real trend: computed tax of the last 5 saved calculations (oldest → newest)
    final taxState = ref.watch(taxProvider);
    final items = taxState.history.take(5).toList().reversed.toList();
    final spots = <FlSpot>[];
    final labels = <String>[];
    final dateFormat = DateFormat('MMM yy');
    for (var i = 0; i < items.length; i++) {
      spots.add(FlSpot(i.toDouble(), items[i].computedTax));
      final dt = items[i].createdAt;
      labels.add(dt != null ? dateFormat.format(dt.toLocal()) : '');
    }
    final hasTrend = spots.length >= 2;
    final maxY = spots.isEmpty
        ? 100000.0
        : spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);

    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tax Liability Trends',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Last ${items.length} run${items.length == 1 ? '' : 's'}',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: hasTrend
                        ? LineChart(
                            LineChartData(
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: maxY > 0 ? maxY / 4 : 1,
                                getDrawingHorizontalLine: (value) => FlLine(
                                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                                  strokeWidth: 1,
                                ),
                              ),
                              titlesData: FlTitlesData(
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final idx = value.toInt();
                                      if (idx >= 0 && idx < labels.length && labels[idx].isNotEmpty) {
                                        return Text(labels[idx], style: theme.textTheme.labelSmall);
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: spots,
                                  isCurved: true,
                                  color: theme.colorScheme.primary,
                                  barWidth: 3,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        theme.colorScheme.primary.withValues(alpha: 0.3),
                                        theme.colorScheme.primary.withValues(alpha: 0.0),
                                      ],
                                    ),
                                  ),
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter: (spot, pct, bar, idx) => FlDotCirclePainter(
                                      radius: 4,
                                      color: theme.colorScheme.primary,
                                      strokeWidth: 2,
                                      strokeColor: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Text(
                              'Run 2+ calculations to see your tax trend',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _typeLabel(TaxProfile p) {
    final first = p.breakdown.isNotEmpty ? p.breakdown.first.bracket : '';
    if (first.startsWith('Flat')) return first;
    if (p.isExempt) return 'Exempt';
    return 'Annual PAYE';
  }

  String _dateLabel(TaxProfile p) {
    final dt = p.createdAt;
    if (dt == null) return 'On this device';
    return DateFormat('d MMM yyyy').format(dt.toLocal());
  }

  Widget _historyTable(ThemeData theme, List<TaxProfile> history, String Function(double) naira, bool isMobile) {
    if (history.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Past Calculations',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'No calculations yet — run your first assessment.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Past Calculations',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            if (isMobile)
              Column(
                children: history.map((h) => _historyMobileCard(theme, h, naira)).toList(),
              )
            else
              Table(
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
                  4: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: ['Date', 'Type', 'Gross Income', 'Tax Computed', ''].map(
                      (h) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          h,
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ).toList(),
                  ),
                  ...history.map((h) => TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(_dateLabel(h), style: theme.textTheme.bodySmall),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _typeLabel(h),
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(naira(h.annualGross), style: theme.textTheme.bodySmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          naira(h.computedTax),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.govRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        tooltip: 'Download Tax Report',
                        onPressed: () => PdfService.exportTaxReport(
                          h,
                          userName: ref.read(authProvider).user?.displayName,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _historyMobileCard(ThemeData theme, TaxProfile h, String Function(double) naira) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_dateLabel(h), style: theme.textTheme.labelSmall),
                  const SizedBox(height: 4),
                  Text(_typeLabel(h), style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  naira(h.computedTax),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.govRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  tooltip: 'Download Tax Report',
                  onPressed: () => PdfService.exportTaxReport(
                    h,
                    userName: ref.read(authProvider).user?.displayName,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
