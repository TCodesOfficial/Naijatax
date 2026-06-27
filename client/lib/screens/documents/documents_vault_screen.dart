import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/guest_restriction_dialog.dart';

class DocumentsVaultScreen extends ConsumerWidget {
  const DocumentsVaultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;
    final authState = ref.watch(authProvider);

    if (authState.isGuest || authState.status == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showGuestRestrictionDialog(context);
      });
    }

    final docs = [
      _DocItem('GTBank_Statement_Jan_Mar.pdf', '2.4 MB', '12 Mar 2025', Icons.description_outlined),
      _DocItem('Zenith_Annual_2023.csv', '1.1 MB', '5 Jan 2025', Icons.table_chart_outlined),
      _DocItem('FirstBank_Oct.pdf', '800 KB', '15 Oct 2024', Icons.description_outlined),
    ];

    final reports = [
      _DocItem('2023 Tax Clearance.pdf', '340 KB', '28 Dec 2023', Icons.picture_as_pdf_outlined),
      _DocItem('Q3 VAT Return Summary.pdf', '210 KB', '1 Oct 2024', Icons.picture_as_pdf_outlined),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Documents',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Manage your bank statements and generated tax reports.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.upload, size: 18),
                label: const Text('Upload'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _bankStatementsCard(theme, docs)),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _taxReportsCard(theme, reports),
                          const SizedBox(height: 16),
                          _secureStorageCard(theme),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _bankStatementsCard(theme, docs),
                    const SizedBox(height: 16),
                    _taxReportsCard(theme, reports),
                    const SizedBox(height: 16),
                    _secureStorageCard(theme),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _bankStatementsCard(ThemeData theme, List<_DocItem> docs) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bank Statements',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ...docs.map((doc) => _docTile(theme, doc)),
          ],
        ),
      ),
    );
  }

  Widget _taxReportsCard(ThemeData theme, List<_DocItem> reports) {
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
                color: theme.colorScheme.tertiaryContainer,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.verified, color: theme.colorScheme.tertiaryContainer, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Tax Reports',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...reports.map((doc) => _docTile(theme, doc, isReport: true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _docTile(ThemeData theme, _DocItem doc, {bool isReport = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        doc.icon,
        color: isReport ? theme.colorScheme.tertiary : theme.colorScheme.primary,
      ),
      title: Text(doc.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      subtitle: Text('${doc.size} • ${doc.date}', style: theme.textTheme.bodySmall),
      trailing: IconButton(
        icon: Icon(
          isReport ? Icons.download_outlined : Icons.more_vert,
          size: 20,
        ),
        onPressed: () {},
      ),
    );
  }

  Widget _secureStorageCard(ThemeData theme) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Your documents are encrypted and stored securely.',
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
}

class _DocItem {
  final String name;
  final String size;
  final String date;
  final IconData icon;
  _DocItem(this.name, this.size, this.date, this.icon);
}
