import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/app_formatter.dart';

import '../../core/utils/tax_hints.dart';
import '../../providers/tax_provider.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/custom_text_field.dart';

/// "Percentages" mode: pick a flat income-tax band plus pension/relief
/// rates as chips. A live estimate card updates as you type; pressing
/// Calculate saves the real result to history via the server.
class PercentageForm extends ConsumerStatefulWidget {
  const PercentageForm({super.key});

  @override
  ConsumerState<PercentageForm> createState() => _PercentageFormState();
}

class _PercentageFormState extends ConsumerState<PercentageForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  final _incomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _turnoverController = TextEditingController();
  final _assetsController = TextEditingController();

  double _bandRate = 15; // %
  double _pensionRate = 8; // %
  double _reliefRate = 20; // %

  static const _bandOptions = [0.0, 15.0, 18.0, 21.0, 23.0, 25.0];
  static const _pensionOptions = [0.0, 5.0, 8.0, 10.0, 15.0];
  static const _reliefOptions = [0.0, 10.0, 20.0];

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _incomeController.dispose();
    _rentController.dispose();
    _turnoverController.dispose();
    _assetsController.dispose();
    super.dispose();
  }

  FlatEstimate get _estimate => TaxHints.flatEstimate(
        annualGross: TaxHints.parseAmount(_incomeController.text) * 12,
        pensionRate: _pensionRate / 100,
        rentPaid: TaxHints.parseAmount(_rentController.text),
        rentReliefRate: _reliefRate / 100,
        flatRate: _bandRate / 100,
      );

  void _calculate() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    ref.read(taxProvider.notifier).calculate(
          monthlyIncome: TaxHints.parseAmount(_incomeController.text),
          rentPaid: TaxHints.parseAmount(_rentController.text),
          pensionRate: _pensionRate / 100,
          turnover: TaxHints.parseAmount(_turnoverController.text),
          assets: TaxHints.parseAmount(_assetsController.text),
          flatRate: _bandRate / 100,
          rentReliefRate: _reliefRate / 100,
        );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final isLoading = ref.watch(
        taxProvider.select((s) => s.status == TaxStatus.loading));
    final est = _estimate;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Flat Percentage',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Pick a rate and we\'ll apply it to your taxable income. '
                'The result is saved to your history.',
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _incomeController,
                label: 'Monthly Gross Income (₦)',
                hintText: 'e.g. 250,000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                useThousandsSeparator: true,
                onChanged: (_) => setState(() {}),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Income is required';
                  if (double.tryParse(v.replaceAll(',', '')) == null) {
                    return 'Enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _rentController,
                label: 'Rent Paid Annually (₦) - Optional',
                hintText: 'e.g. 500,000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                useThousandsSeparator: true,
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 16),
              _chipGroup(
                theme,
                label: 'Income Tax Band',
                icon: Icons.percent_rounded,
                options: _bandOptions,
                selected: _bandRate,
                format: (v) => v == 0 ? '0% (Exempt)' : '${v.toStringAsFixed(0)}%',
                onSelected: (v) => setState(() => _bandRate = v),
              ),
              const SizedBox(height: 12),
              _chipGroup(
                theme,
                label: 'Pension Contribution',
                icon: Icons.savings_outlined,
                options: _pensionOptions,
                selected: _pensionRate,
                format: (v) => '${v.toStringAsFixed(0)}%',
                onSelected: (v) => setState(() => _pensionRate = v),
              ),
              const SizedBox(height: 12),
              _chipGroup(
                theme,
                label: 'Rent Relief',
                icon: Icons.home_outlined,
                options: _reliefOptions,
                selected: _reliefRate,
                format: (v) => '${v.toStringAsFixed(0)}%',
                onSelected: (v) => setState(() => _reliefRate = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _turnoverController,
                      label: 'Turnover (₦) - Optional',
                      hintText: 'e.g. 10,000,000',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      useThousandsSeparator: true,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      controller: _assetsController,
                      label: 'Net Assets (₦) - Optional',
                      hintText: 'e.g. 5,000,000',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      useThousandsSeparator: true,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ─── Live estimate ────────────────────────────────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated annual tax',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppFormatter.nairaDecimal(est.computedTax),
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          _miniStat(theme, 'Taxable', TaxHints.compactNaira(est.taxableIncome)),
                          _miniStat(theme, 'Take-home', TaxHints.compactNaira(est.netIncome)),
                          _miniStat(theme, 'Effective', '${est.effectiveRate.toStringAsFixed(1)}%'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              AnimatedButton(
                onPressed: _calculate,
                text: 'Calculate & Save',
                isLoading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniStat(ThemeData theme, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $value',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _chipGroup(
    ThemeData theme, {
    required String label,
    required IconData icon,
    required List<double> options,
    required double selected,
    required String Function(double) format,
    required ValueChanged<double> onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 6),
            Text(
              label,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((v) {
            final isSelected = v == selected;
            return ChoiceChip(
              label: Text(format(v)),
              selected: isSelected,
              onSelected: (_) => onSelected(v),
              showCheckmark: false,
              labelStyle: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              selectedColor: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.surfaceContainerLow,
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outlineVariant,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
