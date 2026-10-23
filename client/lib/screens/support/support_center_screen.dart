import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_snack.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/animated_button.dart';

class SupportCenterScreen extends ConsumerStatefulWidget {
  const SupportCenterScreen({super.key});

  @override
  ConsumerState<SupportCenterScreen> createState() => _SupportCenterScreenState();
}

class _SupportCenterScreenState extends ConsumerState<SupportCenterScreen> {
  String _selectedIssueType = '';
  final _subjectController = TextEditingController();
  final _descController = TextEditingController();

  static const _supportEmail = 'support@naijataxenlighten.com';

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    final issue =
        _selectedIssueType.isEmpty ? 'General' : _selectedIssueType;
    final subject = _subjectController.text.trim();
    final body = _descController.text.trim();
    if (subject.isEmpty) {
      showAppSnack(context, 'Please add a subject first.');
      return;
    }
    final uri = Uri.parse(
      'mailto:$_supportEmail'
      '?subject=${Uri.encodeComponent('[$issue] $subject')}'
      '&body=${Uri.encodeComponent(body)}',
    );
    final ok = await launchUrl(uri);
    if (!mounted) return;
    if (ok) {
      showAppSnack(
          context, 'Opening your email app to send the ticket…', success: true);
    } else {
      showAppSnack(
          context,
          'Could not open your email app. Please email us at $_supportEmail',
          error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= AppConstants.tabletBreakpoint;

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? 24 : 16,
        isDesktop ? 24 : 16,
        isDesktop ? 24 : 16,
        isDesktop ? 24 : 92,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Help & Support',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Chat with the AI tax assistant or email our support team.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _leftColumn(theme)),
                    const SizedBox(width: 24),
                    Expanded(flex: 1, child: _supportForm(theme)),
                  ],
                )
              : Column(
                  children: [
                    _leftColumn(theme),
                    const SizedBox(height: 24),
                    _supportForm(theme),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _leftColumn(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick action — opens the real in-app AI assistant.
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => context.go('/chat'),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.smart_toy_outlined,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Assistant',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ask our AI tax expert — available 24/7',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Help Topics',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _faqTile(theme, Icons.receipt_long_outlined, 'Tax Returns', 'Filing guides and deadlines'),
        _faqTile(theme, Icons.person_outlined, 'Account Settings', 'Profile and security management'),
        _faqTile(theme, Icons.payments_outlined, 'Payments & Refunds', 'Payment methods and refund status'),
        _faqTile(theme, Icons.business_outlined, 'Corporate Tax (CIT)', 'Business tax compliance and exemptions'),
      ],
    );
  }

  Widget _faqTile(ThemeData theme, IconData icon, String title, String subtitle) {
    // Informational only — no FAQ pages exist yet, so no tap target/chevron.
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
      ),
    );
  }

  Widget _supportForm(ThemeData theme) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bug_report_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Technical Support',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Issue Type'),
              items: const [
                DropdownMenuItem(value: 'login', child: Text('Login / Access Issue')),
                DropdownMenuItem(value: 'calculator', child: Text('Calculator Error')),
                DropdownMenuItem(value: 'upload', child: Text('Document Upload Failure')),
                DropdownMenuItem(value: 'other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _selectedIssueType = v ?? ''),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _subjectController,
              label: 'Subject',
              hintText: 'Brief description of your issue',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Provide details about the issue...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedButton(
              onPressed: _submitTicket,
              text: 'Email Support',
              icon: const Icon(Icons.send, size: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Opens your email app with the details prefilled — we\'ll reply by email.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
