import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_constants.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/app_logo.dart';

class WebLandingScreen extends StatelessWidget {
  const WebLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
          tooltip: 'Go back',
        ),
        title: Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppLogo(radius: 18, iconSize: 20),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  AppConstants.appName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        centerTitle: false,
        actions: [
          if (!isDesktop)
            IconButton(
              onPressed: () => context.go('/login'),
              icon: const Icon(Icons.login_rounded, size: 20),
              tooltip: 'Sign In',
            ),
          if (isDesktop)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: TextButton(
                onPressed: () => context.go('/login'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: const Text('Sign In'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedButton(
              onPressed: () => context.go('/login'),
              text: 'Get Started',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHero(context, theme, isDesktop),
            _buildStatsBar(context, theme, isDesktop),
            _buildFeatures(context, theme, isDesktop),
            _buildHowItWorks(context, theme, isDesktop),
            _buildCtaBanner(context, theme, isDesktop),
            _buildFooter(context, theme),
          ],
        ),
      ),
    );
  }

  // ─── Hero Section ────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context, ThemeData theme, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: isDesktop ? 80 : 48,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.06),
            theme.colorScheme.surface,
            theme.colorScheme.secondary.withValues(alpha: 0.04),
          ],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? Row(
                  children: [
                    Expanded(child: _heroContent(context, theme, isDesktop)),
                    const SizedBox(width: 80),
                    Expanded(child: _heroVisual(theme)),
                  ],
                )
              : Column(
                  children: [
                    _heroVisual(theme),
                    const SizedBox(height: 40),
                    _heroContent(context, theme, isDesktop),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _heroContent(BuildContext context, ThemeData theme, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'NTA 2025 Compliant',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ).animate().fadeIn(delay: 200.ms).slideX(begin: -0.1),
        const SizedBox(height: 20),
        Text(
          'Master the 2025\nNigeria Tax Act Reforms',
          style: GoogleFonts.plusJakartaSans(
            fontSize: isDesktop ? 42 : 28,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
            height: 1.15,
            letterSpacing: -0.5,
          ),
        ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.15),
        const SizedBox(height: 20),
        Text(
          'Understand and plan your taxes with confidence. Run complex PAYE calculations, '
          'check CIT exemption statuses, upload bank statements for AI parsing, and '
          'learn via community support.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.6,
          ),
        ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.1),
        const SizedBox(height: 36),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          children: [
            AnimatedButton(
              onPressed: () => context.go('/login'),
              text: 'Launch App',
              icon: const Icon(Icons.rocket_launch, size: 18),
            ).animate().fadeIn(delay: 800.ms).slideX(begin: -0.1),
            AnimatedButton(
              onPressed: () => context.go('/login'),
              text: 'Try Calculator',
              isOutlined: true,
              icon: const Icon(Icons.calculate_outlined, size: 18),
            ).animate().fadeIn(delay: 900.ms).slideX(begin: -0.1),
          ],
        ),
      ],
    );
  }

  Widget _heroVisual(ThemeData theme) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -30,
            right: -30,
            width: 120,
            height: 120,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            width: 80,
            height: 80,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          // Center icon
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.analytics_outlined,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                const SizedBox(height: 16),
                Text(
                  'Smart Tax Intelligence',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PAYE • CIT • VAT • AI',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).scale(begin: const Offset(0.95, 0.95));
  }

  // ─── Stats Bar ───────────────────────────────────────────────────────────
  Widget _buildStatsBar(BuildContext context, ThemeData theme, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 40,
      ),
      color: theme.colorScheme.primary,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: isDesktop
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statItem(theme, '50+', 'VAT Items'),
                    _statDivider(theme),
                    _statItem(theme, '10K+', 'Calculations'),
                    _statDivider(theme),
                    _statItem(theme, '99%', 'Accuracy'),
                    _statDivider(theme),
                    _statItem(theme, '24/7', 'AI Assistant'),
                  ],
                )
              : Wrap(
                  spacing: 32,
                  runSpacing: 24,
                  alignment: WrapAlignment.center,
                  children: [
                    _statItem(theme, '50+', 'VAT Items'),
                    _statItem(theme, '10K+', 'Calculations'),
                    _statItem(theme, '99%', 'Accuracy'),
                    _statItem(theme, '24/7', 'AI Assistant'),
                  ],
                ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _statItem(ThemeData theme, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _statDivider(ThemeData theme) {
    return Container(
      height: 40,
      width: 1,
      color: Colors.white.withValues(alpha: 0.3),
    );
  }

  // ─── Features Grid ──────────────────────────────────────────────────────
  Widget _buildFeatures(BuildContext context, ThemeData theme, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 80,
      ),
      color: Colors.white,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Text(
                'Everything You Need',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 12),
              Text(
                'Powerful tools to navigate Nigerian tax compliance with ease',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ).animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 48),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: isDesktop ? 1.0 : 1.1,
                children: [
                  _featureCard(
                    theme,
                    icon: Icons.calculate_outlined,
                    title: 'PAYE Calculator',
                    description:
                        'Compute accurate PAYE using NTA 2025 progressive brackets and relief deductions.',
                    color: theme.colorScheme.primary,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                  _featureCard(
                    theme,
                    icon: Icons.smart_toy_outlined,
                    title: 'AI Tax Assistant',
                    description:
                        'Ask questions about Nigerian tax law and get instant, contextual answers from AI.',
                    color: theme.colorScheme.secondary,
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
                  _featureCard(
                    theme,
                    icon: Icons.groups_outlined,
                    title: 'Community Forum',
                    description:
                        'Connect with tax professionals and peers to discuss compliance questions.',
                    color: theme.colorScheme.tertiary,
                  ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
                  _featureCard(
                    theme,
                    icon: Icons.school_outlined,
                    title: 'Tax Education',
                    description:
                        'Learn about the 2025 reforms through guides, articles, and interactive quizzes.',
                    color: const Color(0xFFB91C1C),
                  ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.1),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: color),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── How It Works ────────────────────────────────────────────────────────
  Widget _buildHowItWorks(
      BuildContext context, ThemeData theme, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 80,
      ),
      color: theme.colorScheme.surfaceContainerLow,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              Text(
                'How It Works',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ).animate().fadeIn(),
              const SizedBox(height: 48),
              isDesktop
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: _stepCard(theme, '01', Icons.upload_file_outlined,
                              'Upload', 'Upload your bank\nstatement PDF'),
                        ),
                        _stepConnector(theme),
                        Flexible(
                          child: _stepCard(theme, '02', Icons.calculate_outlined,
                              'Calculate', 'AI parses and\ncomputes your tax'),
                        ),
                        _stepConnector(theme),
                        Flexible(
                          child: _stepCard(theme, '03', Icons.picture_as_pdf_outlined,
                              'Export', 'Download your\nPDF tax report'),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        _stepCard(theme, '01', Icons.upload_file_outlined,
                            'Upload', 'Upload your bank statement PDF'),
                        const SizedBox(height: 16),
                        _stepConnectorVertical(theme),
                        const SizedBox(height: 16),
                        _stepCard(theme, '02', Icons.calculate_outlined,
                            'Calculate', 'AI parses and computes your tax'),
                        const SizedBox(height: 16),
                        _stepConnectorVertical(theme),
                        const SizedBox(height: 16),
                        _stepCard(theme, '03', Icons.picture_as_pdf_outlined,
                            'Export', 'Download your PDF tax report'),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _stepCard(ThemeData theme, String number, IconData icon, String title,
      String desc) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 36),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          desc,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _stepConnector(ThemeData theme) {
    return Container(
      width: 60,
      padding: const EdgeInsets.only(bottom: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (i) => Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.symmetric(horizontal: 3),
            decoration: BoxDecoration(
              color:
                  theme.colorScheme.primary.withValues(alpha: 0.3 + (i * 0.2)),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepConnectorVertical(ThemeData theme) {
    return Column(
      children: List.generate(
        3,
        (i) => Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(vertical: 3),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.3 + (i * 0.2)),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // ─── CTA Banner ──────────────────────────────────────────────────────────
  Widget _buildCtaBanner(
      BuildContext context, ThemeData theme, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 60 : 24,
        vertical: 60,
      ),
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
        child: Column(
          children: [
            Text(
              'Start Your Tax Journey Today',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: isDesktop ? 36 : 28,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ).animate().fadeIn(),
            const SizedBox(height: 16),
            Text(
              'Join thousands of Nigerians taking control of their tax compliance',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.85),
              ),
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 32),
            AnimatedButton(
              onPressed: () => context.go('/login'),
              text: 'Get Started Free',
              backgroundColor: Colors.white,
              foregroundColor: theme.colorScheme.primary,
              icon: const Icon(Icons.arrow_forward, size: 18),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          ],
        ),
      ),
    );
  }

  // ─── Footer ──────────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context, ThemeData theme) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 40 : 20,
        vertical: 32,
      ),
      color: theme.colorScheme.onSurface,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isDesktop
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.account_balance,
                                color: theme.colorScheme.inversePrimary,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  AppConstants.appName,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          spacing: 12,
                          runSpacing: 8,
                          children: [
                            _footerLink(theme, 'Privacy Policy'),
                            _footerLink(theme, 'Terms of Service'),
                            _footerLink(theme, 'Contact'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Divider(color: Colors.white.withValues(alpha: 0.15)),
                    const SizedBox(height: 16),
                    Text(
                      '© 2025 ${AppConstants.appName}. Built for the 2025 Nigeria Tax Act reforms.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.account_balance,
                          color: theme.colorScheme.inversePrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppConstants.appName,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        _footerLink(theme, 'Privacy Policy'),
                        _footerLink(theme, 'Terms of Service'),
                        _footerLink(theme, 'Contact'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Divider(color: Colors.white.withValues(alpha: 0.15)),
                    const SizedBox(height: 12),
                    Text(
                      '© 2025 ${AppConstants.appName}.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'Built for the 2025 Nigeria Tax Act reforms.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _footerLink(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: Colors.white.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}
