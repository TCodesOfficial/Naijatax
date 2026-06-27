import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/theme_colors.dart';

class NtaBracketsScreen extends ConsumerStatefulWidget {
  const NtaBracketsScreen({super.key});

  @override
  ConsumerState<NtaBracketsScreen> createState() => _NtaBracketsScreenState();
}

class _NtaBracketsScreenState extends ConsumerState<NtaBracketsScreen> {
  double _annualIncome = 3500000;

  // NTA 2025 bands (annual)
  final _bands = [
     _Band('Exempt (≤₦800k)', 0.0, 800000),
     _Band('₦800k–₦3.8M', 0.15, 3000000),
     _Band('₦3.8M–₦6.8M', 0.20, 3000000),
     _Band('₦6.8M–₦20.8M', 0.22, 14000000),
     _Band('Above ₦20.8M', 0.25, double.infinity),
  ];

  // NTA 2025: flat ₦800k exemption (replaces old CRA)
  double get _cra => 800000;
  double get _chargeableIncome => max(0, _annualIncome - _cra);

  double get _totalTax {
    double remaining = _chargeableIncome;
    double tax = 0;
    for (final band in _bands) {
      if (remaining <= 0) break;
      final bandLimit = band.limit == double.infinity ? remaining : min(band.limit, remaining);
      tax += bandLimit * band.rate;
      remaining -= bandLimit;
    }
    final minTax = _annualIncome * 0.01;
    return max(tax, minTax);
  }

  double get _effectiveRate => _annualIncome > 0 ? (_totalTax / _annualIncome) * 100 : 0;

  double get _monthlyTakeHome => (_annualIncome - _totalTax) / 12;

  List<double> get _bandAmounts {
    double remaining = _chargeableIncome;
    final amounts = <double>[];
    for (final band in _bands) {
      if (remaining <= 0) {
        amounts.add(0);
        continue;
      }
      final bandLimit = band.limit == double.infinity ? remaining : min(band.limit, remaining);
      amounts.add(bandLimit * band.rate);
      remaining -= bandLimit;
    }
    return amounts;
  }

  String _naira(double v) {
    if (v >= 1000000) return '₦${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '₦${(v / 1000).toStringAsFixed(0)}K';
    return '₦${v.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final amounts = _bandAmounts;
    final maxAmount = amounts.isNotEmpty ? amounts.reduce(max) : 1.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax Bracket Visualizer',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Adjust your income to see how it distributes across Nigerian tax bands.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          isMobile
              ? Column(
                  children: [
                    _controlsCard(theme),
                    const SizedBox(height: 16),
                    _infoCard(theme),
                    const SizedBox(height: 16),
                    _chartCard(theme, amounts, maxAmount),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _controlsCard(theme)),
                    const SizedBox(width: 20),
                    Expanded(flex: 1, child: _infoCard(theme)),
                  ],
                ),
          if (!isMobile) ...[
            const SizedBox(height: 20),
            _chartCard(theme, amounts, maxAmount),
          ],
        ],
      ),
    );
  }

  Widget _controlsCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estimated Annual Income',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '₦${_annualIncome.toStringAsFixed(0)}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Effective Rate: ${_effectiveRate.toStringAsFixed(1)}%',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _annualIncome,
              min: 0,
              max: 15000000,
              divisions: 100,
              onChanged: (v) => setState(() => _annualIncome = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('₦0', style: theme.textTheme.labelSmall),
                Text('₦15M+', style: theme.textTheme.labelSmall),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Quick Stats',
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _statRow(theme, 'Total Tax Liability', _naira(_totalTax), const Color(0xFFB91C1C)),
            _statRow(theme, 'Consolidated Relief (CRA)', _naira(_cra), const Color(0xFF15803D)),
            _statRow(theme, 'Chargeable Income', _naira(_chargeableIncome), theme.colorScheme.onSurface),
            _statRow(theme, 'Monthly Take-Home', _naira(_monthlyTakeHome), theme.colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _statRow(ThemeData theme, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'How it works',
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Nigeria uses a progressive tax system. Higher income portions are taxed at higher rates.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Current Breakdown',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            ..._bands.map((b) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.3 + (_bands.indexOf(b) * 0.12)),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${b.label}: ${(b.rate * 100).toStringAsFixed(0)}%',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            )),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Generate Full Report'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _chartCard(ThemeData theme, List<double> amounts, double maxAmount) {
    final barColors = [
      theme.colorScheme.primary.withValues(alpha: 0.3),
      theme.colorScheme.primary.withValues(alpha: 0.45),
      theme.colorScheme.primary.withValues(alpha: 0.6),
      theme.colorScheme.primary.withValues(alpha: 0.75),
      theme.colorScheme.primary.withValues(alpha: 0.9),
      AppColors.govRed.withValues(alpha: 0.8),
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Income Distribution Across Tax Bands',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxAmount > 0 ? maxAmount * 1.2 : 100000,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '₦${rod.toY.toStringAsFixed(0)}',
                          const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 || idx >= _bands.length) return const SizedBox();
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _bands[idx].label.replaceAll('Next ', '').replaceAll('Above ', ''),
                              style: theme.textTheme.labelSmall?.copyWith(fontSize: 9),
                            ),
                          );
                        },
                        reservedSize: 36,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: maxAmount > 0 ? maxAmount / 4 : 1,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                      strokeWidth: 1,
                    ),
                  ),
                  barGroups: List.generate(amounts.length, (i) {
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: amounts[i],
                          color: barColors[i],
                          width: 32,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Band {
  final String label;
  final double rate;
  final double limit;
  _Band(this.label, this.rate, this.limit);
}
