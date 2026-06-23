import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/animated_button.dart';

class WebLandingScreen extends StatelessWidget {
  const WebLandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─── Header Navigation ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_balance, color: theme.colorScheme.primary, size: 32),
                      const SizedBox(width: 10),
                      Text(
                        'NaijaTax Enlighten',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => context.go('/login'),
                        child: const Text('Sign In'),
                      ),
                      const SizedBox(width: 16),
                      AnimatedButton(
                        onPressed: () => context.go('/register'),
                        text: 'Get Started',
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ─── Hero Section ───────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              color: theme.colorScheme.surfaceContainerLow,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Master the 2025 Nigeria Tax Act Reforms',
                              style: theme.textTheme.displayLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              'Understand and plan your taxes with confidence. Run complex PAYE calculations, check CIT exemption statuses, upload statements for AI parsing, and learn via community support.',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                AnimatedButton(
                                  onPressed: () => context.go('/login'),
                                  text: 'Launch App',
                                ),
                                const SizedBox(width: 16),
                                AnimatedButton(
                                  onPressed: () {
                                    // Navigate to guest assessment directly
                                    context.go('/login');
                                  },
                                  text: 'Try Calculator',
                                  isOutlined: true,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (isDesktop) ...[
                        const SizedBox(width: 80),
                        Expanded(
                          child: Container(
                            height: 400,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 30,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.analytics_outlined,
                                size: 160,
                                color: theme.colorScheme.primary.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // ─── Features Grid ──────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
              color: Colors.white,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      Text(
                        'What We Offer',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 60),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isDesktop ? 3 : 1,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.4,
                        children: [
                          _featureCard(
                            theme,
                            icon: Icons.calculate,
                            title: 'PAYE & CIT Calculator',
                            description: 'Ensure accurate tax deductions matching the latest progressive brackets of the 2025 Act.',
                          ),
                          _featureCard(
                            theme,
                            icon: Icons.psychology,
                            title: 'AI Statement Parsing',
                            description: 'Upload bank statements in PDF to automatically parse income sources and prepare tax drafts.',
                          ),
                          _featureCard(
                            theme,
                            icon: Icons.forum,
                            title: 'Community Forums',
                            description: 'Ask and answer tax compliance questions anonymously or with verified credentials.',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _featureCard(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 36, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
