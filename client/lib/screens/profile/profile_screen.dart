import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/biometric_service.dart';
import '../../widgets/guest_restriction_dialog.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricEnabled = false;
  bool _biometricHardwareAvailable = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await BiometricService.isAvailable();
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool(AppConstants.biometricKey) ?? false;
    setState(() {
      _biometricHardwareAvailable = available;
      _biometricEnabled = enabled;
    });
  }

  Future<void> _toggleBiometrics(bool enabled) async {
    if (enabled) {
      final success = await BiometricService.authenticate(
        reason: 'Verify your identity to enable biometric sign-in',
      );
      if (!success) return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.biometricKey, enabled);
    setState(() {
      _biometricEnabled = enabled;
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Theme.of(ctx).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Text(
                'Change Profile Photo',
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null || !mounted) return;

    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, maxWidth: 512, maxHeight: 512, imageQuality: 80);
      if (picked == null || !mounted) return;

      setState(() => _isUploading = true);

      final bytes = await picked.readAsBytes();
      final ext = picked.path.split('.').last;
      final fileName = '${ref.read(authProvider).user?.id ?? "guest"}_${DateTime.now().millisecondsSinceEpoch}.$ext';

      final client = Supabase.instance.client;
      await client.storage.from('avatars').uploadBinary(
        fileName,
        bytes,
        fileOptions: const FileOptions(upsert: true),
      );
      final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);

      if (!mounted) return;
      ref.read(authProvider.notifier).updateAvatar(publicUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile photo updated!'), backgroundColor: Colors.green),
        );
      }
    } on StorageException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${e.message}'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (mounted) {
        final msg = e.toString().contains('Supabase')
            ? 'Photo upload unavailable in demo mode'
            : 'Upload failed: $e';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider);

    final String displayName = authState.user != null
        ? (authState.user!.displayName ?? authState.user!.email?.split('@').first ?? 'User')
        : 'Guest User';
    final String email = authState.user?.email ?? '';

    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        // ─── Profile Card ────────────────────────────────────────────────
        Card(
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
                  height: 8,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: theme.colorScheme.primaryContainer,
                            backgroundImage: authState.user?.avatarUrl != null
                                ? CachedNetworkImageProvider(authState.user!.avatarUrl!)
                                : null,
                            child: authState.user?.avatarUrl == null
                                ? Icon(
                                    Icons.person,
                                    size: 40,
                                    color: theme.colorScheme.primary,
                                  )
                                : null,
                          ),
                          if (_isUploading)
                            const Positioned.fill(
                              child: CircleAvatar(
                                backgroundColor: Colors.black38,
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _isUploading ? null : _pickAndUploadAvatar,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondaryContainer,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  size: 14,
                                  color: theme.colorScheme.onSecondaryContainer,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    displayName,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.tertiaryContainer,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.verified,
                                        size: 14,
                                        color: theme.colorScheme.onPrimaryContainer,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Verified',
                                        style: theme.textTheme.labelSmall?.copyWith(
                                          color: theme.colorScheme.onPrimaryContainer,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (email.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ─── Settings Accordion Cards ────────────────────────────────────
        _settingsTile(
          theme,
          icon: Icons.person_outlined,
          title: 'Personal Details',
          subtitle: 'Update your name, contact info, and address.',
          onTap: () {},
        ),
        _settingsTile(
          theme,
          icon: Icons.account_balance_outlined,
          title: 'Tax Preferences',
          subtitle: 'Manage your default tax region and filing status.',
          onTap: () {},
        ),
        _settingsTile(
          theme,
          icon: Icons.notifications_active_outlined,
          title: 'Notification Settings',
          subtitle: 'Control email and push alert preferences.',
          trailing: _comingSoonBadge(theme),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This feature is coming soon!')),
            );
          },
        ),
        _settingsTile(
          theme,
          icon: Icons.palette_outlined,
          title: 'Theme (Light/Dark)',
          subtitle: 'Customize the application\'s appearance.',
          trailing: Switch(
            value: isDarkMode,
            onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
          ),
          onTap: () => ref.read(themeProvider.notifier).toggle(),
        ),

        // ─── Privacy & Security (with accent bar) ───────────────────────
        Card(
          child: Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Column(
              children: [
                if (_biometricHardwareAvailable && authState.user != null)
                  SwitchListTile(
                    title: const Text('Biometric Authentication'),
                    value: _biometricEnabled,
                    secondary: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.fingerprint,
                        color: theme.colorScheme.onPrimaryContainer,
                        size: 20,
                      ),
                    ),
                    onChanged: _toggleBiometrics,
                  ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.security,
                      color: theme.colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  title: Row(
                    children: [
                      const Text('Privacy & Security'),
                      const SizedBox(width: 8),
                      _comingSoonBadge(theme),
                    ],
                  ),
                  subtitle: const Text('Manage passwords, 2FA, and data access.'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('This feature is coming soon!')),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),

        // ─── Support & Documents ─────────────────────────────────────────
        _settingsTile(
          theme,
          icon: Icons.help_outline,
          title: 'Support Center',
          subtitle: 'Get help with using the app.',
          trailing: _comingSoonBadge(theme),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('This feature is coming soon!')),
            );
          },
        ),
        _settingsTile(
          theme,
          icon: Icons.folder_outlined,
          title: 'My Documents',
          subtitle: 'Manage bank statements and tax reports.',
          onTap: () {
            if (authState.isGuest) {
              showGuestRestrictionDialog(context);
            } else {
              context.go('/profile/documents');
            }
          },
        ),
        _settingsTile(
          theme,
          icon: Icons.verified_user_outlined,
          title: 'Verify Account',
          subtitle: 'Complete identity verification for full access.',
          onTap: () {
            if (authState.isGuest) {
              showGuestRestrictionDialog(context);
            } else {
              context.go('/profile/verify');
            }
          },
        ),
        const SizedBox(height: 20),

        // ─── Logout Button ──────────────────────────────────────────────
        if (authState.user != null)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () => ref.read(authProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFFB91C1C),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFFB91C1C)),
                ),
              ),
            ),
          )
        else
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Log In / Register'),
            ),
          ),
      ],
    );
  }

  Widget _comingSoonBadge(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Coming Soon',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.onTertiaryContainer,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _settingsTile(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Card(
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 20),
          ),
          title: Text(
            title,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          trailing: trailing ??
              Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant),
          onTap: onTap,
        ),
      ),
    );
  }
}
