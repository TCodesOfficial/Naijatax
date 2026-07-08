import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  bool _isPhoneMode = false;
  bool _otpSent = false;
  String? _pendingPhone;

  @override
  void dispose() {
    _displayNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _submitEmail() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Passwords do not match'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      ref
          .read(authProvider.notifier)
          .signUpWithEmail(
            _emailController.text.trim(),
            _passwordController.text,
            displayName: _displayNameController.text.trim().isNotEmpty
                ? _displayNameController.text.trim()
                : null,
          );
    }
  }

  void _submitPhone() async {
    final phone = '+234${_phoneController.text.trim()}';
    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your phone number')),
      );
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Passwords do not match'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    await ref
        .read(authProvider.notifier)
        .signUpWithPhone(phone, _passwordController.text);
  }

  void _verifyOtp() async {
    if (_otpController.text.trim().length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 6-digit OTP')),
      );
      return;
    }

    await ref
        .read(authProvider.notifier)
        .verifyOtp(_pendingPhone!, _otpController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authProvider);

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 900;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        final router = GoRouter.of(context);
        if (!mounted) return;
        final hasOnboarded = next.user?.onboarded ?? false;
        router.go(hasOnboarded ? '/dashboard' : '/onboarding');
      } else if (next.needsOtpVerification) {
        setState(() {
          _otpSent = true;
          _pendingPhone = next.pendingPhone;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent! Check your phone.'),
            backgroundColor: Colors.green,
          ),
        );
      } else if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.08),
              Colors.white,
              theme.colorScheme.secondary.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: isDesktop
            ? _buildDesktopLayout(theme, authState)
            : _buildMobileLayout(theme, authState),
      ),
    );
  }

  Widget _buildDesktopLayout(ThemeData theme, AuthState authState) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primaryContainer,
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const AppLogo(radius: 40, iconSize: 44),
                    const SizedBox(height: 24),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Master the 2025 Nigeria Tax Act Reforms.\nCalculate, learn, and stay compliant.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: _buildFormCard(theme, authState),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(ThemeData theme, AuthState authState) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: _buildFormCard(theme, authState),
        ),
      ),
    );
  }

  Widget _buildFormCard(ThemeData theme, AuthState authState) {
    if (authState.status == AuthStatus.awaitingConfirmation) {
      return _buildEmailVerificationCard(theme, authState);
    }

    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          ref.read(authProvider.notifier).continueAsGuest();
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: theme.colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Guest',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                Icons.arrow_outward,
                                size: 14,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppConstants.appName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Create your account to start tracking taxes.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),

                    Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _isPhoneMode = false;
                                _otpSent = false;
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: !_isPhoneMode
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Email',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: !_isPhoneMode
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _isPhoneMode = true;
                                _otpSent = false;
                              }),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: _isPhoneMode
                                      ? theme.colorScheme.primary
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Phone',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: _isPhoneMode
                                        ? theme.colorScheme.onPrimary
                                        : theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (!_isPhoneMode) ...[
                      CustomTextField(
                        controller: _displayNameController,
                        label: 'Username',
                        hintText: 'johndoe',
                        keyboardType: TextInputType.name,
                        prefixIcon: const Icon(Icons.person_outlined, size: 20),
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _emailController,
                        label: 'Email Address',
                        hintText: 'you@example.com',
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: const Icon(Icons.mail_outlined, size: 20),
                        validator: (v) => v == null || !v.contains('@')
                            ? 'Enter a valid email'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _passwordController,
                        label: 'Password',
                        hintText:
                            '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                        validator: (v) => v == null || v.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        label: 'Confirm Password',
                        hintText:
                            '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                        obscureText: true,
                        prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                        validator: (v) =>
                            v == null ? 'Confirm password is required' : null,
                      ),
                      const SizedBox(height: 14),
                      AnimatedButton(
                        onPressed: _submitEmail,
                        text: 'Sign Up',
                        isLoading: authState.status == AuthStatus.loading,
                        icon: const Icon(Icons.arrow_forward, size: 18),
                      ),
                    ] else ...[
                      if (!_otpSent) ...[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.outlineVariant,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    color:
                                        theme.colorScheme.surfaceContainerLow,
                                  ),
                                  child: Text(
                                    '+234',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: TextFormField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: theme.textTheme.bodyMedium,
                                    decoration: const InputDecoration(
                                      hintText: '8012345678',
                                    ),
                                    validator: (v) => v == null || v.length < 10
                                        ? 'Enter a valid phone number'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          hintText:
                              '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                          validator: (v) => v == null || v.length < 6
                              ? 'Password must be at least 6 characters'
                              : null,
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          hintText:
                              '\u2022\u2022\u2022\u2022\u2022\u2022\u2022\u2022',
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outlined, size: 20),
                          validator: (v) =>
                              v == null ? 'Confirm password is required' : null,
                        ),
                        const SizedBox(height: 14),
                        AnimatedButton(
                          onPressed: _submitPhone,
                          text: 'Send OTP',
                          isLoading: authState.status == AuthStatus.loading,
                          icon: const Icon(Icons.send, size: 18),
                        ),
                      ] else ...[
                        Text(
                          'Enter the 6-digit code sent to $_pendingPhone',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          controller: _otpController,
                          label: 'OTP Code',
                          hintText: '000000',
                          keyboardType: TextInputType.number,
                          maxLength: 6,
                          prefixIcon: const Icon(Icons.pin_outlined, size: 20),
                        ),
                        const SizedBox(height: 14),
                        AnimatedButton(
                          onPressed: _verifyOtp,
                          text: 'Verify & Create Account',
                          isLoading: authState.status == AuthStatus.loading,
                          icon: const Icon(Icons.check_circle, size: 18),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _otpSent = false;
                            });
                          },
                          child: const Text('Change phone number'),
                        ),
                      ],
                    ],

                    const SizedBox(height: 12),

                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Or continue with',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _socialButton(
                          theme,
                          Icons.g_mobiledata,
                          'Google',
                          () => ref
                              .read(authProvider.notifier)
                              .signInWithGoogle(),
                        ),
                        const SizedBox(width: 12),
                        _socialButton(
                          theme,
                          Icons.apple,
                          'Apple',
                          () =>
                              ref.read(authProvider.notifier).signInWithApple(),
                        ),
                        const SizedBox(width: 12),
                        _socialButton(
                          theme,
                          Icons.facebook,
                          'Facebook',
                          () => ref
                              .read(authProvider.notifier)
                              .signInWithFacebook(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    Wrap(
                      alignment: WrapAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Text(
                            'Sign In',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        ),
      );
  }

  Widget _buildEmailVerificationCard(ThemeData theme, AuthState authState) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.mark_email_read_outlined,
                size: 48,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Check Your Email',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'We sent a verification link to',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              authState.pendingEmail ?? '',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Click the link in your email to verify\nyour account and continue.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: AnimatedButton(
                onPressed: null,
                text: 'Waiting for you...',
                isLoading: true,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Didn't get the email?",
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            GestureDetector(
              onTap: () => ref.read(authProvider.notifier).resendConfirmation(),
              child: Text(
                'Resend Email',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () => context.go('/login'),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Back to Sign In',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _socialButton(
    ThemeData theme,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Container(
      width: 56,
      height: 48,
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
      ),
    );
  }
}
