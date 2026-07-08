import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/theme/theme_colors.dart';
import '../../providers/tax_provider.dart';
import '../../services/pdf_service.dart';

class AnalyticsHistoryScreen extends ConsumerWidget {
  const AnalyticsHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final taxState = ref.watch(taxProvider);
    final naira = NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 2);

    // Sample historical data
    final history = [
      _CalcHistory('12 Oct 2024', 'Annual PAYE', 8500000.0, 1250400.0),
      _CalcHistory('5 Jun 2024', 'Monthly PAYE', 700000.0, 104200.0),
      _CalcHistory('15 Jan 2024', 'Annual PAYE', 7800000.0, 1140000.0),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
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
                    _historyTable(theme, history, naira, isMobile, taxState),
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
                    _historyTable(theme, history, naira, isMobile, taxState),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _incomeAllocationCard(ThemeData theme, TaxState taxState) {
    final gross = taxState.profile?.annualGross ?? 8500000.0;
    final tax = taxState.profile?.computedTax ?? 1250400.0;
    final pension = gross * 0.08;
    final net = gross - tax - pension;

    final sections = [
      PieChartSectionData(
        value: net,
        color: theme.colorScheme.primary,
        radius: 50,
        title: '',
      ),
      PieChartSectionData(
        value: tax,
        color: AppColors.govRed,
        radius: 50,
        title: '',
      ),
      PieChartSectionData(
        value: pension,
        color: theme.colorScheme.tertiary,
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
                      'Total Gross: ₦${(gross / 1000000).toStringAsFixed(1)}M',
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _legendItem(theme, 'Net Pay', '${((net / gross) * 100).toStringAsFixed(0)}%', theme.colorScheme.primary),
                  _legendItem(theme, 'Income Tax (PAYE)', '${((tax / gross) * 100).toStringAsFixed(0)}%', AppColors.govRed),
                  _legendItem(theme, 'Pension', '${((pension / gross) * 100).toStringAsFixed(0)}%', theme.colorScheme.tertiary),
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
    const spots = [
      FlSpot(0, 800000),
      FlSpot(1, 920000),
      FlSpot(2, 1050000),
      FlSpot(3, 1140000),
      FlSpot(4, 1250400),
    ];
    const labels = ['2020', '2021', '2022', '2023', '2024'];

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
                          'Last 5 Years',
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 250000,
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
                                if (idx >= 0 && idx < labels.length) {
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

  Widget _historyTable(ThemeData theme, List<_CalcHistory> history, NumberFormat naira, bool isMobile, TaxState taxState) {
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
                children: history.map((h) => _historyMobileCard(theme, h, naira, taxState)).toList(),
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
                        child: Text(h.date, style: theme.textTheme.bodySmall),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          h.type,
                          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(naira.format(h.gross), style: theme.textTheme.bodySmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          naira.format(h.tax),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.govRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                        tooltip: 'Download Tax Report',
                        onPressed: taxState.profile != null
                            ? () => PdfService.exportTaxReport(taxState.profile!)
                            : null,
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

  Widget _historyMobileCard(ThemeData theme, _CalcHistory h, NumberFormat naira, TaxState taxState) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(h.date, style: theme.textTheme.labelSmall),
                const SizedBox(height: 4),
                Text(h.type, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  naira.format(h.tax),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.govRed,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 16),
                  tooltip: 'Download Tax Report',
                  onPressed: taxState.profile != null
                      ? () => PdfService.exportTaxReport(taxState.profile!)
                      : null,
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

class _CalcHistory {
  final String date;
  final String type;
  final double gross;
  final double tax;
  _CalcHistory(this.date, this.type, this.gross, this.tax);
}
