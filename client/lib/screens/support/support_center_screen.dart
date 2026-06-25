import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _subjectController.dispose();
    _descController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
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
            'Find answers, connect with tax professionals, or let our AI guide you.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search help articles...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
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
        // Quick Actions
        Row(
          children: [
            Expanded(
              child: _quickActionCard(
                theme,
                icon: Icons.smart_toy_outlined,
                title: 'AI Assistant',
                subtitle: 'Ask our AI tax expert',
                bgColor: theme.colorScheme.primaryContainer,
                iconColor: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _quickActionCard(
                theme,
                icon: Icons.support_agent_outlined,
                title: 'Contact Expert',
                subtitle: 'Speak with a professional',
                bgColor: theme.colorScheme.surfaceContainerLow,
                iconColor: theme.colorScheme.tertiary,
                borderColor: theme.colorScheme.tertiaryContainer,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'FAQ Categories',
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

  Widget _quickActionCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color bgColor,
    required Color iconColor,
    Color? borderColor,
  }) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor ?? theme.colorScheme.outlineVariant,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqTile(ThemeData theme, IconData icon, String title, String subtitle) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: theme.textTheme.bodySmall),
        trailing: Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
        onTap: () {},
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
              onPressed: () {
                final issue = _selectedIssueType.isEmpty ? 'General' : _selectedIssueType;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Support ticket submitted ($issue)')),
                );
              },
              text: 'Submit Ticket',
              icon: const Icon(Icons.send, size: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Our support team typically responds within 24 hours.',
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
