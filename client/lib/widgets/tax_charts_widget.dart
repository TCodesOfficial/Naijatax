import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/tax_profile.dart';

class TaxChartsWidget extends StatelessWidget {
  final TaxProfile profile;

  const TaxChartsWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income Allocation Breakdown',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            isMobile
                ? Column(
                    children: [
                      SizedBox(height: 180, child: _buildPieChart(theme)),
                      const SizedBox(height: 16),
                      _buildLegend(theme),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(flex: 3, child: SizedBox(height: 180, child: _buildPieChart(theme))),
                      const SizedBox(width: 16),
                      Expanded(flex: 2, child: _buildLegend(theme)),
                    ],
                  ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              'Tax Savings (Old vs. 2025 NTA)',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            SizedBox(height: 200, child: _buildBarChart(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(ThemeData theme) {
    final double netVal = profile.netIncome.toDouble();
    final double taxVal = profile.computedTax.toDouble();
    final double dedVal = (profile.pensionDeduction + profile.rentRelief).toDouble();
    final double total = netVal + taxVal + dedVal;

    if (total <= 0) {
      return const Center(child: Text('No data to show'));
    }

    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            color: const Color(0xFF15803D), // Success Green
            value: netVal,
            title: '${((netVal / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: const Color(0xFFB91C1C), // Gov Red
            value: taxVal,
            title: '${((taxVal / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          PieChartSectionData(
            color: const Color(0xFF0060AC), // Secondary Blue
            value: dedVal,
            title: '${((dedVal / total) * 100).toStringAsFixed(0)}%',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _legendItem(const Color(0xFF15803D), 'Net Take-Home'),
        const SizedBox(height: 8),
        _legendItem(const Color(0xFFB91C1C), 'Tax Liability (PAYE)'),
        const SizedBox(height: 8),
        _legendItem(const Color(0xFF0060AC), 'Deductions / Reliefs'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildBarChart(ThemeData theme) {
    final double computedTax = profile.computedTax.toDouble();
    // Simulate old tax as being higher if there are savings, or compute it
    final double oldTax = computedTax + profile.savings.toDouble();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: oldTax > 0 ? oldTax * 1.2 : 100,
        barTouchData: BarTouchData(enabled: true),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, TitleMeta meta) {
                switch (value.toInt()) {
                  case 0:
                    return const Text('Old Tax Act', style: TextStyle(fontWeight: FontWeight.bold));
                  case 1:
                    return const Text('NTA 2025', style: TextStyle(fontWeight: FontWeight.bold));
                  default:
                    return const Text('');
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(
            x: 0,
            barRods: [
              BarChartRodData(
                toY: oldTax,
                color: const Color(0xFF757684), // Slate Gray
                width: 32,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: [
              BarChartRodData(
                toY: computedTax,
                color: const Color(0xFF00288E), // Primary Blue
                width: 32,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
