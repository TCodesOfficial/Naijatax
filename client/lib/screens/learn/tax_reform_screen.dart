import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/dummy/dev_data.dart';
import '../../models/learn_section.dart';

class TaxReformScreen extends StatelessWidget {
  const TaxReformScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final sections = DevData.learnSections;

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
