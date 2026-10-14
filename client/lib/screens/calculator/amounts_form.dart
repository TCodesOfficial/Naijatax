import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../core/utils/tax_hints.dart';
import '../../services/api_service.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/tax_hint_pill.dart';

typedef AmountsSubmit = void Function({
  required double monthlyIncome,
  required double rentPaid,
  required double pensionRate,
  required double turnover,
  required double assets,
});

/// "Amounts" mode: classic form where every field shows a live tax hint
/// pill (marginal band, relief value, pension deduction, CIT class).
class AmountsForm extends StatefulWidget {
  final bool isLoading;
  final AmountsSubmit onCalculate;

  const AmountsForm({
    super.key,
    required this.isLoading,
    required this.onCalculate,
  });

  @override
  State<AmountsForm> createState() => _AmountsFormState();
}

class _AmountsFormState extends State<AmountsForm>
    with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();

  final _incomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _pensionController = TextEditingController(text: '8');
  final _turnoverController = TextEditingController();
  final _assetsController = TextEditingController();

  bool _isUploading = false;
  String? _uploadError;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _incomeController.dispose();
    _rentController.dispose();
    _pensionController.dispose();
    _turnoverController.dispose();
    _assetsController.dispose();
    super.dispose();
  }

  void _calculate() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onCalculate(
        monthlyIncome: TaxHints.parseAmount(_incomeController.text),
        rentPaid: TaxHints.parseAmount(_rentController.text),
        pensionRate: (double.tryParse(_pensionController.text) ?? 8) / 100,
        turnover: TaxHints.parseAmount(_turnoverController.text),
        assets: TaxHints.parseAmount(_assetsController.text),
      );
    }
  }

  Future<void> _pickAndParseStatement() async {
    setState(() {
      _isUploading = true;
      _uploadError = null;
    });

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _isUploading = false);
        return;
      }

      final file = result.files.first;
      final bytes = await file.readAsBytes();
      final dioFile = MultipartFile.fromBytes(bytes, filename: file.name);

      final parsed = await ApiService.instance.parseStatement(dioFile);

      // Auto-fill form values with parsed values
      if (parsed['monthlyIncome'] != null) {
        _incomeController.text = parsed['monthlyIncome'].toString();
      }
      if (parsed['rentPaid'] != null) {
        _rentController.text = parsed['rentPaid'].toString();
      }
      if (parsed['pensionRate'] != null) {
        _pensionController.text =
            ((parsed['pensionRate'] as num) * 100).toStringAsFixed(0);
      }

      setState(() {
        _isUploading = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Statement parsed and inputs pre-filled!'),
            backgroundColor: Colors.green),
      );

      _calculate();
    } catch (e) {
      setState(() {
        _isUploading = false;
        _uploadError = 'Parsing failed: ${e.toString()}';
      });
    }
  }

  // ─── Live hints ──────────────────────────────────────────────────────────

  Widget? _incomeHint() {
    final gross = TaxHints.parseAmount(_incomeController.text) * 12;
    if (gross <= 0) return null;
    final pension = TaxHints.pensionDeduction(
        gross, (double.tryParse(_pensionController.text) ?? 8) / 100);
    final relief = TaxHints.rentRelief(TaxHints.parseAmount(_rentController.text));
    final taxable =
        TaxHints.taxableIncome(annualGross: gross, pension: pension, relief: relief);
    return TaxHintPill(
      text: '${TaxHints.compactNaira(gross)}/yr · ${TaxHints.marginalLabel(taxable)}',
    );
  }

  Widget? _rentHint() {
    final rent = TaxHints.parseAmount(_rentController.text);
    if (rent <= 0) return null;
    return TaxHintPill(
      text: '20% relief · ${TaxHints.compactNaira(TaxHints.rentRelief(rent))}',
      icon: Icons.home_outlined,
    );
  }

  Widget? _pensionHint() {
    final gross = TaxHints.parseAmount(_incomeController.text) * 12;
    final rate = double.tryParse(_pensionController.text);
    if (gross <= 0 || rate == null || rate <= 0) return null;
    return TaxHintPill(
      text: '${TaxHints.compactNaira(TaxHints.pensionDeduction(gross, rate / 100))}/yr',
      icon: Icons.savings_outlined,
    );
  }

  Widget? _citHint() {
    final turnover = TaxHints.parseAmount(_turnoverController.text);
    final assets = TaxHints.parseAmount(_assetsController.text);
    if (turnover <= 0 && assets <= 0) return null;
    final rate = TaxHints.citRate(turnover, assets);
    final color = rate == 'EXEMPT' ? Colors.green : null;
    return TaxHintPill(text: 'CIT: $rate', icon: Icons.business_outlined, color: color);
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Tax Parameters',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _incomeController,
                label: 'Monthly Gross Income (₦)',
                hintText: 'e.g. 250,000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                useThousandsSeparator: true,
                suffix: _incomeHint(),
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
                label: 'Rent Paid Annually (₦)',
                hintText: 'e.g. 500,000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                useThousandsSeparator: true,
                suffix: _rentHint(),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _pensionController,
                label: 'Pension Contribution Rate (%)',
                hintText: 'e.g. 8',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                suffix: _pensionHint(),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _turnoverController,
                label: 'Business Turnover / Revenue (₦) - Optional',
                hintText: 'e.g. 10,000,000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                useThousandsSeparator: true,
                suffix: _citHint(),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: _assetsController,
                label: 'Business Net Assets (₦) - Optional',
                hintText: 'e.g. 5,000,000',
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                useThousandsSeparator: true,
                suffix: _citHint(),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: AnimatedButton(
                      onPressed: _calculate,
                      text: 'Calculate Tax',
                      isLoading: widget.isLoading,
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: _pickAndParseStatement,
                    tooltip: 'Upload bank statement PDF',
                    icon: _isUploading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.upload_file),
                    style: IconButton.styleFrom(
                      backgroundColor: theme.colorScheme.surfaceContainerHigh,
                      foregroundColor: theme.colorScheme.primary,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              if (_uploadError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _uploadError!,
                  style:
                      TextStyle(color: theme.colorScheme.error, fontSize: 13),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
