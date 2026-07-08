import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tax_provider.dart';
import '../../services/pdf_service.dart';
import '../../widgets/guest_restriction_dialog.dart';

class DocumentsVaultScreen extends ConsumerStatefulWidget {
  const DocumentsVaultScreen({super.key});

  @override
  ConsumerState<DocumentsVaultScreen> createState() => _DocumentsVaultScreenState();
}

class _DocumentsVaultScreenState extends ConsumerState<DocumentsVaultScreen> {
  List<FileObject> _files = [];
  bool _isLoading = true;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final auth = ref.read(authProvider);
    if (auth.isGuest || auth.status == AuthStatus.unauthenticated) return;

    setState(() => _isLoading = true);
    try {
      final userId = auth.user?.id;
      if (userId == null) return;
      final files = await Supabase.instance.client
          .storage
          .from('documents')
          .list(path: userId);
      if (mounted) setState(() => _files = files);
    } catch (_) {
      if (mounted) setState(() => _files = []);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadFile() async {
    final auth = ref.read(authProvider);
    if (auth.isGuest || auth.status == AuthStatus.unauthenticated) {
      showGuestRestrictionDialog(context);
      return;
    }

    final result = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'csv', 'xlsx', 'doc', 'docx'],
    );
    if (result == null || !mounted) return;

    final file = result;
    final bytes = await file.readAsBytes();

    setState(() => _isUploading = true);
    try {
      final userId = auth.user?.id;
      if (userId == null) return;
      final ext = file.name.split('.').last;
      final fileName = '$userId/${DateTime.now().millisecondsSinceEpoch}.$ext';

      await Supabase.instance.client.storage.from('documents').uploadBinary(
        fileName,
        bytes,
        fileOptions: FileOptions(
          upsert: true,
          contentType: _contentType(ext),
        ),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully'), backgroundColor: Colors.green),
        );
        await _loadFiles();
      }
    } on StorageException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.message}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _downloadFile(FileObject file) async {
    try {
      final userId = ref.read(authProvider).user?.id;
      if (userId == null) return;
      final path = '$userId/${file.name}';
      final bytes = await Supabase.instance.client.storage.from('documents').download(path);

      final saved = await FilePicker.saveFile(
        fileName: file.name,
        bytes: Uint8List.fromList(bytes),
      );
      if (saved == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Download cancelled')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _deleteFile(FileObject file) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete File'),
        content: Text('Delete "${file.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFB91C1C)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    try {
      final userId = ref.read(authProvider).user?.id;
      if (userId == null) return;
      await Supabase.instance.client.storage.from('documents').remove(['$userId/${file.name}']);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File deleted'), backgroundColor: Colors.green),
        );
        await _loadFiles();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _generateTaxReport() async {
    final taxState = ref.read(taxProvider);
    if (taxState.profile == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No tax data available. Calculate tax first.'), backgroundColor: Colors.orange),
        );
      }
      return;
    }

    setState(() => _isUploading = true);
    try {
      final auth = ref.read(authProvider);
      final userId = auth.user?.id;
      if (userId == null) return;

      final pdfBytes = await PdfService.generateTaxReportBytes(taxState.profile!);
      final fileName = '$userId/Tax_Report_${DateFormat.yMMMd().format(DateTime.now())}.pdf';

      await Supabase.instance.client.storage.from('documents').uploadBinary(
        fileName,
        pdfBytes,
        fileOptions: const FileOptions(upsert: true, contentType: 'application/pdf'),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tax report generated and saved!'), backgroundColor: Colors.green),
        );
        await _loadFiles();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to generate report: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _contentType(String ext) {
    switch (ext) {
      case 'pdf': return 'application/pdf';
      case 'csv': return 'text/csv';
      case 'xlsx': return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case 'doc': return 'application/msword';
      case 'docx': return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default: return 'application/octet-stream';
    }
  }

  IconData _iconForFile(String name) {
    if (name.endsWith('.pdf')) return Icons.picture_as_pdf_outlined;
    if (name.endsWith('.csv') || name.endsWith('.xlsx')) return Icons.table_chart_outlined;
    return Icons.description_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;
    final authState = ref.watch(authProvider);

    if (authState.isGuest || authState.status == AuthStatus.unauthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showGuestRestrictionDialog(context);
      });
    }

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
                onPressed: _isUploading ? null : _uploadFile,
                icon: _isUploading
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.upload, size: 18),
                label: Text(_isUploading ? 'Uploading...' : 'Upload'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _bankStatementsCard(theme)),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _taxReportsCard(theme),
                          const SizedBox(height: 16),
                          _secureStorageCard(theme),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _bankStatementsCard(theme),
                    const SizedBox(height: 16),
                    _taxReportsCard(theme),
                    const SizedBox(height: 16),
                    _secureStorageCard(theme),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _bankStatementsCard(ThemeData theme) {
    final statementFiles = _files.where((f) => !f.name.toLowerCase().contains('tax_report')).toList();

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
            if (_isLoading)
              const Center(child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ))
            else if (statementFiles.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(Icons.folder_open, size: 48, color: theme.colorScheme.outline),
                      const SizedBox(height: 12),
                      Text(
                        'No bank statements uploaded yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Upload PDF or CSV bank statements for tax analysis.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            else
              ...statementFiles.map((file) => _fileTile(theme, file)),
          ],
        ),
      ),
    );
  }

  Widget _taxReportsCard(ThemeData theme) {
    final reportFiles = _files.where((f) => f.name.toLowerCase().contains('tax_report')).toList();

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
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _isUploading ? null : _generateTaxReport,
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: const Text('Generate Tax Report PDF'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (reportFiles.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'No reports generated yet.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    )
                  else
                    ...reportFiles.map((file) => _fileTile(theme, file, isReport: true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fileTile(ThemeData theme, FileObject file, {bool isReport = false}) {
    final sizeStr = _formatBytes(file.metadata?['size'] ?? 0);
    final dateStr = file.createdAt != null
        ? DateFormat('d MMM yyyy').format(DateTime.parse(file.createdAt!))
        : '';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        _iconForFile(file.name),
        color: isReport ? theme.colorScheme.tertiary : theme.colorScheme.primary,
      ),
      title: Text(
        file.name.contains('/') ? file.name.split('/').last : file.name,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text('$sizeStr • $dateStr', style: theme.textTheme.bodySmall),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              isReport ? Icons.download_outlined : Icons.download_outlined,
              size: 20,
            ),
            tooltip: 'Download',
            onPressed: () => _downloadFile(file),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: 'Delete',
            onPressed: () => _deleteFile(file),
          ),
        ],
      ),
    );
  }

  String _formatBytes(dynamic bytes) {
    final b = bytes is int ? bytes : 0;
    if (b < 1024) return '$b B';
    if (b < 1024 * 1024) return '${(b / 1024).toStringAsFixed(1)} KB';
    return '${(b / (1024 * 1024)).toStringAsFixed(1)} MB';
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
                'Your documents are encrypted and stored securely in your private vault.',
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
