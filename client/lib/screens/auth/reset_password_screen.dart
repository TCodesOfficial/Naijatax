import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_text_field.dart';

/// Step 2 of password recovery: verify the 6-digit code and set a new
/// password. The code establishes a session; the new password is applied
/// on top of it (a failed update can be retried without re-verifying).
class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;

  const ResetPasswordScreen({super.key, this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _isSubmitting = false;
  bool _verified = false;
  String? _error;

  @override
  void dispose() {
    _otpController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final email = widget.email;
    if (email == null) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_passwordController.text != _confirmController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final notifier = ref.read(authProvider.notifier);

    if (!_verified) {
      final verifyErr =
          await notifier.verifyRecoveryOtp(email, _otpController.text.trim());
      if (verifyErr != null) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _error = verifyErr;
          });
        }
        return;
      }
      _verified = true;
    }

    final saveErr = await notifier.setNewPassword(_passwordController.text);
    if (!mounted) return;
    if (saveErr != null) {
      setState(() {
        _isSubmitting = false;
        _error = saveErr;
      });
      return;
    }

    // Session is active — redirect (may adjust to /onboarding via RULE 1b).
    GoRouter.of(context).go('/dashboard');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = widget.email;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/login');
            }
          },
        ),
        title: const Text('Reset Password'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.08),
              theme.colorScheme.surface,
              theme.colorScheme.secondary.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: email == null
                  ? _missingEmail(theme)
                  : Form(
                      key: _formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerLowest,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.shadow
                                  .withValues(alpha: 0.08),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant
                                .withValues(alpha: 0.5),
                          ),
                        ),
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(
                                child: AppLogo(radius: 32, iconSize: 36)),
                            const SizedBox(height: 16),
                            Text(
                              'Set New Password',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter the 6-digit code sent to $email and choose a new password.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 20),
                            CustomTextField(
                              controller: _otpController,
                              label: '6-Digit Code',
                              hintText: '000000',
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              prefixIcon:
                                  const Icon(Icons.pin_outlined, size: 20),
                              validator: (v) =>
                                  v == null || v.trim().length != 6
                                      ? 'Enter the 6-digit code'
                                      : null,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _passwordController,
                              label: 'New Password',
                              obscureText: true,
                              prefixIcon:
                                  const Icon(Icons.lock_outlined, size: 20),
                              validator: (v) => v == null || v.length < 6
                                  ? 'Password must be at least 6 characters'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            CustomTextField(
                              controller: _confirmController,
                              label: 'Confirm New Password',
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline,
                                  size: 20),
                              validator: (v) =>
                                  v == null || v.isEmpty
                                      ? 'Confirm your new password'
                                      : null,
                            ),
                            if (_error != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                _error!,
                                style: TextStyle(
                                  color: theme.colorScheme.error,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            const SizedBox(height: 20),
                            AnimatedButton(
                              onPressed: _isSubmitting ? null : _submit,
                              isLoading: _isSubmitting,
                              text: _verified
                                  ? 'Save New Password'
                                  : 'Verify & Update',
                              icon: const Icon(Icons.check_circle, size: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _missingEmail(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Request a reset code first.',
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => context.go('/forgot-password'),
          child: const Text('Back to Forgot Password'),
        ),
      ],
    );
  }
}
