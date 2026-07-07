import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/learn_section.dart';

class TaxReformScreen extends StatelessWidget {
  const TaxReformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final sections = [
      LearnSection(
        title: 'Overview of the NTA 2025',
        icon: Icons.gavel_outlined,
        summary:
            'The 2025 Nigeria Tax Act (NTA) is a landmark legislation signed into law by President Bola Ahmed Tinubu in June 2025, effective January 1, 2026. It fundamentally restructures Nigeria\'s fiscal framework with three core goals: relief for low-income earners, administrative efficiency, and simplified business compliance.',
        highlights: [
          'FIRS transitions into the Nigeria Revenue Service (NRS) as the modernized single collector for all federal revenues',
          'Personal income tax threshold raised to ₦800,000 annually, exempting minimum wage earners from PAYE',
          'Small businesses with turnover below ₦100 million are completely exempt from Company Income Tax',
          'New progressive tax bands replace the old system for individual taxpayers',
          'Enhanced digital filing portal for streamlined tax compliance',
        ],
      ),
      LearnSection(
        title: 'PAYE Brackets & Income Tax',
        icon: Icons.receipt_long_outlined,
        summary:
            'Under the new progressive tax bands, personal income tax is calculated annually. The system provides significant relief for low and middle-income earners while maintaining a fair top marginal rate for high earners.',
        highlights: [
          'First ₦800,000: Exempt (0% rate) — up from ₦300,000 under the old system',
          'Next ₦3,000,000: Taxed at 15%',
          'Next ₦3,000,000: Taxed at 20%',
          'Next ₦14,000,000: Taxed at 22%',
          'Above ₦20,800,000: Top rate of 25%',
          'Mandatory 8% employee pension contribution (tax-deductible)',
          'Rent relief: 20% of rent paid, capped at ₦500,000 per year',
        ],
        linkRoute: '/calculator/nta-brackets',
        linkLabel: 'View Tax Brackets',
      ),
      LearnSection(
        title: 'VAT Changes & Categories',
        icon: Icons.shopping_cart_outlined,
        summary:
            'The standard VAT rate remains at 7.5%, but the reforms clarify the scope of VAT application, especially for digital services. Essential goods and services are zero-rated or exempt to protect low-income households.',
        highlights: [
          'Standard rate: 7.5% on standard-rated goods and services',
          'Zero-rated (0%): Basic food items (bread, rice, fresh produce), exported goods, solar panels, educational textbooks',
          'Exempt: School tuition, medical services, residential rent, public transport, financial services',
          'Digital services: Clear scope for VAT on electronic and digital services provided in Nigeria',
          '50+ items classified under the new VAT framework',
        ],
        linkRoute: '/calculator',
        linkLabel: 'Check VAT Items',
      ),
      LearnSection(
        title: 'Company Income Tax (CIT)',
        icon: Icons.business_outlined,
        summary:
            'The reforms provide complete tax relief to micro and small businesses to foster economic growth. The CIT structure is now tiered based on company size, protecting over 90% of registered SMEs in Nigeria.',
        highlights: [
          'Small companies (turnover ≤ ₦100M, assets ≤ ₦250M): Completely exempt from CIT',
          'Medium companies (turnover ₦100M–₦500M): Reduced rate of 20%',
          'Large companies (turnover > ₦500M): Standard rate of 30%',
          'Exemption covers over 90% of registered SMEs in Nigeria',
          'Fixed assets threshold: ₦250 million net book value',
        ],
      ),
      LearnSection(
        title: 'Tax Filing & Compliance',
        icon: Icons.assignment_outlined,
        summary:
            'The new reforms introduce a revamped digital filing portal and updated compliance deadlines. The Nigeria Revenue Service (NRS) provides modernized tools for seamless tax filing.',
        highlights: [
          'New FIRS/NRS online tax filing portal with enhanced features',
          'Extended compliance deadline for individual taxpayers under the NTA 2025 framework',
          'Digital-first approach: File returns, track refunds, and manage compliance online',
          'Penalties for non-compliance updated to reflect new thresholds',
          'Tax clearance certificates now issued digitally',
        ],
      ),
      LearnSection(
        title: 'Key Contacts & Resources',
        icon: Icons.contact_phone_outlined,
        summary:
            'Access official resources and get help with your tax questions. Our AI Assistant is trained on the NTA 2025 reforms and can answer common tax questions instantly.',
        highlights: [
          'Nigeria Revenue Service (NRS): Official successor to FIRS for federal tax collection',
          'AI Tax Assistant: Ask questions about NTA 2025 reforms anytime (in-app)',
          'Community Forum: Discuss tax topics with other taxpayers and experts',
          'Tax Practitioners: Consult a certified professional for complex tax matters',
        ],
        linkRoute: '/chat',
        linkLabel: 'Ask AI Assistant',
      ),
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Hero Section ──────────────────────────────────────────────
          _buildHero(theme, isMobile),
          SizedBox(height: isMobile ? 20 : 24),

          // ─── Quick Actions ─────────────────────────────────────────────
          _buildQuickActions(context, theme, isMobile),
          SizedBox(height: isMobile ? 24 : 32),

          // ─── Accordion Sections ────────────────────────────────────────
          Text(
            'Key Reforms',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          if (isMobile)
            Column(
              children: sections
                  .map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildAccordion(context, theme, s),
                      ))
                  .toList(),
            )
          else
            _buildDesktopGrid(context, sections),
        ],
      ),
    );
  }

  Widget _buildHero(ThemeData theme, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'NTA 2025',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Nigeria Tax Act 2025',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Understand the reforms reshaping Nigeria\'s tax landscape — from PAYE brackets to VAT changes and business exemptions.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.5,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'NTA 2025',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Nigeria Tax Act 2025',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Understand the reforms reshaping Nigeria\'s tax landscape — from PAYE brackets to VAT changes and business exemptions.',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withValues(alpha: 0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                Icon(
                  Icons.menu_book_rounded,
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme, bool isMobile) {
    return Row(
      children: [
        Expanded(
          child: _actionCard(
            context,
            theme,
            icon: Icons.quiz_outlined,
            label: 'Take the Quiz',
            subtitle: 'Test your knowledge',
            onTap: () => context.go('/learn/quiz'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _actionCard(
            context,
            theme,
            icon: Icons.smart_toy_outlined,
            label: 'Ask AI Assistant',
            subtitle: 'Get instant answers',
            onTap: () => context.go('/chat'),
          ),
        ),
      ],
    );
  }

  Widget _actionCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: theme.colorScheme.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopGrid(BuildContext context, List<LearnSection> sections) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final itemWidth = isWide
            ? (constraints.maxWidth - 16) / 2
            : constraints.maxWidth;
        return Wrap(
          spacing: 16,
          runSpacing: 12,
          children: sections
              .map((s) => SizedBox(
                    width: itemWidth,
                    child: _buildAccordion(context, theme, s),
                  ))
              .toList(),
        );
      },
    );
  }

  Widget _buildAccordion(BuildContext context, ThemeData theme, LearnSection section) {
    return Card(
      margin: EdgeInsets.zero,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(section.icon, size: 20, color: theme.colorScheme.primary),
          ),
          title: Text(
            section.title,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          trailing: Icon(
            Icons.expand_more,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              section.summary,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 12),
            ...section.highlights.map((h) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          h,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
            if (section.linkRoute != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => context.go(section.linkRoute!),
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: Text(section.linkLabel ?? 'Learn More'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
