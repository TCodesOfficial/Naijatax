import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../services/biometric_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _biometricEnabled = false;
  bool _biometricHardwareAvailable = false;

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeProvider);

    final String displayName = authState.user != null
        ? authState.user!.email.split('@').first
        : 'Guest User';

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // ─── Profile Header ───────────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Text(
                      displayName[0].toUpperCase(),
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    displayName,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  if (authState.user != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      authState.user!.email,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ─── Settings List ────────────────────────────────────────────────
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: isDarkMode,
                  secondary: const Icon(Icons.dark_mode_outlined),
                  onChanged: (val) => ref.read(themeProvider.notifier).toggle(),
                ),
                if (_biometricHardwareAvailable && authState.user != null) ...[
                  const Divider(),
                  SwitchListTile(
                    title: const Text('Biometric Authentication'),
                    value: _biometricEnabled,
                    secondary: const Icon(Icons.fingerprint),
                    onChanged: _toggleBiometrics,
                  ),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Support Center'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ─── Action Button ────────────────────────────────────────────────
          if (authState.user != null)
            ElevatedButton.icon(
              onPressed: () => ref.read(authProvider.notifier).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login),
              label: const Text('Log In / Register'),
            ),
        ],
      ),
    );
  }
}
