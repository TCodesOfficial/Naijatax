import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/tax_provider.dart';
import '../providers/article_provider.dart';
import '../widgets/tax_charts_widget.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $displayName 👋',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Stay compliant with the 2025 Tax Act reforms.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ─── Tax Profile / Quick Actions ──────────────────────────────────
          if (taxState.profile != null) ...[
            Text(
              'Your Latest Tax Assessment',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TaxChartsWidget(profile: taxState.profile!),
            const SizedBox(height: 24),
          ] else ...[
            _buildCalculatorCTA(theme),
            const SizedBox(height: 24),
          ],

          // ─── Economic Metrics ─────────────────────────────────────────────
          Text(
            'Nigeria Economic Indicators',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildEconomicMetrics(theme, articlesState.metrics),
          const SizedBox(height: 24),

          // ─── Latest News ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Tax News & Articles',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () => context.go('/dashboard/education'),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildNewsList(theme, articlesState),
        ],
      ),
    );
  }

  Widget _buildCalculatorCTA(ThemeData theme) {
    return Card(
      color: theme.colorScheme.primaryContainer.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.1)),
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
                    'Input your income and expenses to check computed tax, reliefs, andCIT exemptions.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to Calculator tab (Index 1)
              },
              child: const Text('Calculate'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEconomicMetrics(ThemeData theme, Map<String, dynamic> metrics) {
    final inflation = metrics['inflation'] ?? '22.04%';
    final exchangeRate = metrics['exchangeRate'] ?? '₦1,480 / \$1';
    final gdpGrowth = metrics['gdpGrowth'] ?? '2.98%';

    return LayoutBuilder(builder: (context, constraints) {
      final itemWidth = (constraints.maxWidth - 24) / 3;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _metricCard(theme, 'Inflation Rate', inflation, Icons.trending_up, itemWidth),
          _metricCard(theme, 'USD / NGN', exchangeRate, Icons.currency_exchange, itemWidth),
          _metricCard(theme, 'GDP Growth', gdpGrowth, Icons.show_chart, itemWidth),
        ],
      );
    });
  }

  Widget _metricCard(ThemeData theme, String label, String value, IconData icon, double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Icon(icon, size: 16, color: theme.colorScheme.secondary),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(ThemeData theme, ArticlesState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.articles.take(3).length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, idx) {
        final art = state.articles[idx];
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
          child: ListTile(
            title: Text(
              art.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              art.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              // Navigate to details or open link
            },
          ),
        );
      },
    );
  }
}
