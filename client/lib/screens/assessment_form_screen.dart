import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/tax_provider.dart';
import '../services/api_service.dart';
import '../services/pdf_service.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/tax_charts_widget.dart';

class AssessmentFormScreen extends ConsumerStatefulWidget {
  const AssessmentFormScreen({super.key});

  @override
  ConsumerState<AssessmentFormScreen> createState() =>
      _AssessmentFormScreenState();
}

class _AssessmentFormScreenState extends ConsumerState<AssessmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _incomeController = TextEditingController(text: '250000');
  final _rentController = TextEditingController(text: '0');
  final _pensionController =
      TextEditingController(text: '8'); // represented in %
  final _turnoverController = TextEditingController(text: '0');
  final _assetsController = TextEditingController(text: '0');

  bool _isUploading = false;
  String? _uploadError;

  final _naira =
      NumberFormat.currency(locale: 'en_NG', symbol: '₦', decimalDigits: 2);

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
      final monthlyIncome = double.tryParse(_incomeController.text) ?? 0;
      final rentPaid = double.tryParse(_rentController.text) ?? 0;
      final pensionRate = (double.tryParse(_pensionController.text) ?? 8) / 100;
      final turnover = double.tryParse(_turnoverController.text) ?? 0;
      final assets = double.tryParse(_assetsController.text) ?? 0;

      ref.read(taxProvider.notifier).calculate(
            monthlyIncome: monthlyIncome,
            rentPaid: rentPaid,
            pensionRate: pensionRate,
            turnover: turnover,
            assets: assets,
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
        // Decimal value back to percent
        _pensionController.text =
            ((parsed['pensionRate'] as double) * 100).toStringAsFixed(0);
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final taxState = ref.watch(taxProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ─── Direct Inputs Form ───────────────────────────────────────────
          Card(
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
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _rentController,
                      label: 'Rent Paid Annually (₦)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _pensionController,
                      label: 'Pension Contribution Rate (%)',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _turnoverController,
                      label: 'Business Turnover / Revenue (₦) - Optional',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _assetsController,
                      label: 'Business Net Assets (₦) - Optional',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: AnimatedButton(
                            onPressed: _calculate,
                            text: 'Calculate Tax',
                            isLoading: taxState.status == TaxStatus.loading,
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
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.upload_file),
                          style: IconButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHigh,
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
                        style: TextStyle(
                            color: theme.colorScheme.error, fontSize: 13),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── Results Output ──────────────────────────────────────────────
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
                          onPressed: () =>
                              PdfService.exportTaxReport(taxState.profile!),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _resultRow('Annual Gross Income',
                        _naira.format(taxState.profile!.annualGross)),
                    _resultRow('Pension Deductible',
                        _naira.format(taxState.profile!.pensionDeduction)),
                    _resultRow('Rent Relief Portion',
                        _naira.format(taxState.profile!.rentRelief)),
                    const Divider(height: 24),
                    _resultRow(
                      'Computed Monthly Tax (PAYE)',
                      _naira.format(taxState.profile!.computedTax / 12),
                      valueColor: theme.colorScheme.error,
                      bold: true,
                    ),
                    _resultRow(
                      'Computed Annual Tax (PAYE)',
                      _naira.format(taxState.profile!.computedTax),
                      valueColor: theme.colorScheme.error,
                      bold: true,
                    ),
                    _resultRow(
                      'Annual Net Take-Home',
                      _naira.format(taxState.profile!.netIncome),
                      valueColor: const Color(0xFF15803D),
                      bold: true,
                    ),
                    _resultRow(
                      'Annual Savings vs. Old Act',
                      _naira.format(taxState.profile!.savings),
                      valueColor: theme.colorScheme.secondary,
                      bold: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TaxChartsWidget(profile: taxState.profile!),
          ],
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
          Text(label, style: const TextStyle(fontSize: 14)),
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
