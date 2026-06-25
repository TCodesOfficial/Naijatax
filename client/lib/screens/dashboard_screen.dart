import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import '../providers/tax_provider.dart';
import '../providers/article_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(articlesProvider.notifier).fetchArticles();
      ref.read(articlesProvider.notifier).fetchMetrics();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final authState = ref.watch(authProvider);
    final taxState = ref.watch(taxProvider);
    final articlesState = ref.watch(articlesProvider);

    final String displayName = authState.user != null
        ? authState.user!.email.split('@').first
        : 'Guest';

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Welcome Header ───────────────────────────────────────────────
          _buildWelcomeHeader(theme, displayName),
          SizedBox(height: isMobile ? 20 : 24),

          // ─── Tax at a Glance or Calculator CTA ───────────────────────────
          if (taxState.profile != null)
            _buildTaxGlanceCard(theme, taxState, isMobile)
          else
            _buildCalculatorCTA(theme, isMobile),
          SizedBox(height: isMobile ? 20 : 24),

          // ─── Quick Actions ────────────────────────────────────────────────
          _buildQuickActions(theme, isMobile),
          SizedBox(height: isMobile ? 20 : 24),

          // ─── Recent News ──────────────────────────────────────────────────
          _buildRecentNews(theme, articlesState, isMobile),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(ThemeData theme, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back, $name',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Here's your tax profile summary for the current fiscal year.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  // ─── Tax at a Glance Card ──────────────────────────────────────────────
  Widget _buildTaxGlanceCard(ThemeData theme, TaxState taxState, bool isMobile) {
    final profile = taxState.profile!;
    final annualGross = profile.annualGross;
    final computedTax = profile.computedTax;
    final ratio = annualGross > 0 ? (computedTax / annualGross).clamp(0.0, 1.0) : 0.0;

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
            // Top accent bar
            Container(
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Tax at a Glance',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: isMobile ? 16 : 24),
                  isMobile
                      ? Column(
                          children: [
                            _buildProgressRing(theme, ratio),
                            const SizedBox(height: 16),
                            _buildMetricsGrid(theme, profile),
                          ],
                        )
                      : Row(
                          children: [
                            _buildProgressRing(theme, ratio),
                            const SizedBox(width: 32),
                            Expanded(child: _buildMetricsGrid(theme, profile)),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressRing(ThemeData theme, double ratio) {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 140,
            height: 140,
            child: CircularProgressIndicator(
              value: ratio,
              strokeWidth: 10,
              backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${(ratio * 100).toStringAsFixed(0)}%',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'TAX RATIO',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(ThemeData theme, dynamic profile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _metricBox(
                theme,
                'Estimated Income',
                '₦${(profile.annualGross / 1000000).toStringAsFixed(1)}M',
                theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _metricBox(
                theme,
                'Tax Liability',
                '₦${(profile.computedTax / 1000000).toStringAsFixed(1)}M',
                const Color(0xFFB91C1C),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(8),
            border: const Border(
              left: BorderSide(color: Color(0xFF15803D), width: 4),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'FILING STATUS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'On Track (Due Mar 31)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF15803D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.check_circle,
                color: Color(0xFF15803D),
                size: 24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _metricBox(ThemeData theme, String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Calculator CTA ────────────────────────────────────────────────────
  Widget _buildCalculatorCTA(ThemeData theme, bool isMobile) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.15),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimate Your 2025 Tax Liability',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Input your income and expenses to check computed tax, reliefs, and CIT exemptions.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () => context.go('/calculator'),
                child: const Text('Calculate'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Quick Actions ─────────────────────────────────────────────────────
  Widget _buildQuickActions(ThemeData theme, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            _actionTile(
              theme,
              icon: Icons.calculate_outlined,
              label: 'PAYE Calculator',
              color: theme.colorScheme.primary,
              bgColor: theme.colorScheme.primaryContainer,
              onTap: () => context.go('/calculator'),
            ),
            _actionTile(
              theme,
              icon: Icons.domain_outlined,
              label: 'Business Tax',
              color: theme.colorScheme.secondary,
              bgColor: theme.colorScheme.secondaryContainer,
              onTap: () => context.go('/calculator'),
            ),
            _actionTile(
              theme,
              icon: Icons.receipt_long_outlined,
              label: 'VAT Guide',
              color: theme.colorScheme.tertiary,
              bgColor: theme.colorScheme.tertiaryFixedDim,
              onTap: () => context.go('/calculator'),
            ),
            _actionTile(
              theme,
              icon: Icons.smart_toy_outlined,
              label: 'AI Assistant',
              color: theme.colorScheme.primary,
              bgColor: theme.colorScheme.surfaceTint,
              onTap: () => context.go('/chat'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _actionTile(
    ThemeData theme, {
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Recent News ───────────────────────────────────────────────────────
  Widget _buildRecentNews(ThemeData theme, ArticlesState state, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent News: NTA 2025',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/dashboard/news'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (state.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (state.articles.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No articles available yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          )
        else
          SizedBox(
            height: 180,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: state.articles.take(5).length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, idx) {
                final art = state.articles[idx];
                return _newsCard(theme, art);
              },
            ),
          ),
      ],
    );
  }

  Widget _newsCard(ThemeData theme, dynamic article) {
    final badgeColor = article.source.contains('FIRS') || article.source.contains('Alert')
        ? theme.colorScheme.errorContainer
        : article.source.contains('Guide')
            ? theme.colorScheme.surfaceContainerHigh
            : theme.colorScheme.primaryContainer;
    final badgeLabel = article.source.contains('FIRS') ? 'Alert'
        : article.source.contains('Guide') ? 'Guide' : 'Update';
    final badgeTextColor = article.source.contains('FIRS')
        ? theme.colorScheme.onErrorContainer
        : article.source.contains('Guide')
            ? theme.colorScheme.onSurfaceVariant
            : theme.colorScheme.primaryContainer.computeLuminance() > 0.5
                ? theme.colorScheme.primary
                : theme.colorScheme.onPrimaryContainer;

    return Container(
      width: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badgeLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: badgeTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _timeAgo(article.createdAt),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            article.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              article.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return 'Just now';
  }
}
