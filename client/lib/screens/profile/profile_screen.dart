import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/app_snack.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/avatar_service.dart';
import '../../services/biometric_service.dart';
import '../../widgets/guest_restriction_dialog.dart';
import '../../widgets/user_avatar.dart';

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
    if (!mounted) return;
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
      if (!success || !mounted) return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.biometricKey, enabled);
    if (!mounted) return;
    setState(() {
      _biometricEnabled = enabled;
    });
  }

  Future<void> _pickAndUploadAvatar() async {
    final source = await AvatarService.pickSource(context);
    if (source == null || !mounted) return;

    setState(() => _isUploading = true);
    final userId = ref.read(authProvider).user?.id;
    final result = await AvatarService.pickAndUpload(source, userId: userId);
    if (!mounted) return;
    setState(() => _isUploading = false);

    if (result.ok && result.url != null) {
      await ref.read(authProvider.notifier).updateAvatar(result.url!);
      if (mounted) {
        showAppSnack(context, 'Profile photo updated!', success: true);
      }
    } else if (result.error != null && mounted) {
      showAppSnack(context, result.error!, error: true);
    }
  }

  Future<void> _deleteAvatar() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Photo'),
        content: const Text('Are you sure you want to remove your profile photo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(ctx).colorScheme.error,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;

    setState(() => _isUploading = true);
    final userId = ref.read(authProvider).user?.id;
    final result = await AvatarService.deleteAll(userId);
    if (!mounted) return;
    setState(() => _isUploading = false);

    if (result.ok) {
      await ref.read(authProvider.notifier).deleteAvatar();
      if (mounted) {
        showAppSnack(context, 'Profile photo removed', success: true);
      }
    } else if (mounted) {
      showAppSnack(context, result.error ?? 'Delete failed', error: true);
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
    final size = MediaQuery.of(context).size;
    final hasBottomNav = size.width < AppConstants.tabletBreakpoint;

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        hasBottomNav ? 92 : 16,
      ),
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
                          UserAvatar(
                            avatarUrl: authState.user?.avatarUrl,
                            displayName: displayName,
                            radius: 40,
                            fallbackIcon: Icons.account_circle_outlined,
                            iconSize: 44,
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
                            child: Tooltip(
                              message: 'Change profile photo',
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
                          ),
                          if (authState.user?.avatarUrl != null && authState.user!.avatarUrl!.trim().isNotEmpty)
                            Positioned(
                              top: 0,
                              right: 0,
                               child: Tooltip(
                                message: 'Remove profile photo',
                                child: GestureDetector(
                                  onTap: _isUploading ? null : _deleteAvatar,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.errorContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: theme.colorScheme.onErrorContainer,
                                    ),
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
          onTap: () {
            if (authState.isRestricted) {
              showGuestRestrictionDialog(context);
            } else {
              context.push('/profile/personal-details');
            }
          },
        ),
        _settingsTile(
          theme,
          icon: Icons.history_outlined,
          title: 'Calculation History',
          subtitle: 'Review all your past tax assessments.',
          onTap: () => context.push('/calculator/history'),
        ),
        _settingsTile(
          theme,
          icon: Icons.notifications_active_outlined,
          title: 'Notification Settings',
          subtitle: 'Control email and push alert preferences.',
          trailing: _comingSoonBadge(theme),
          onTap: () {
            showAppSnack(context, 'This feature is coming soon!');
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
          child: Material(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
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
                      const Flexible(
                        child: Text(
                          'Privacy & Security',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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
                    showAppSnack(context, 'This feature is coming soon!');
                  },
                ),
                ],
              ),
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
          onTap: () => context.push('/profile/support'),
        ),
        _settingsTile(
          theme,
          icon: Icons.folder_outlined,
          title: 'My Documents',
          subtitle: 'Manage bank statements and tax reports.',
          onTap: () {
            if (authState.isRestricted) {
              showGuestRestrictionDialog(context);
            } else {
              context.push('/profile/documents');
            }
          },
        ),
        const SizedBox(height: 20),

        // ─── Logout Button ──────────────────────────────────────────────
        if (authState.user != null)
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to sign out of your account?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        style: FilledButton.styleFrom(backgroundColor: theme.colorScheme.error),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );
                if (confirmed == true && mounted) {
                  ref.read(authProvider.notifier).signOut();
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.colorScheme.error),
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
