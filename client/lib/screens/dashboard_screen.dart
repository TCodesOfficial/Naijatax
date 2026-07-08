import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../core/utils/app_formatter.dart';
import '../models/tax_profile.dart';
import '../models/article_model.dart';
import '../providers/auth_provider.dart';
import '../providers/tax_provider.dart';
import '../providers/article_provider.dart';
import '../providers/inflation_provider.dart';
import '../services/pdf_service.dart';

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
      ref.read(inflationProvider.notifier).fetch();

      final auth = ref.read(authProvider);
      if (auth.status == AuthStatus.authenticated) {
        ref.read(taxProvider.notifier).fetchFromServer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated &&
          (prev == null || prev.status != AuthStatus.authenticated)) {
        ref.read(taxProvider.notifier).fetchFromServer();
      }
    });
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    final authState = ref.watch(authProvider);
    final taxState = ref.watch(taxProvider);
    final articlesState = ref.watch(articlesProvider);
    final inflationState = ref.watch(inflationProvider);

    final String displayName = authState.user != null
        ? (authState.user!.displayName ?? authState.user!.email?.split('@').first ?? 'User')
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

          // ─── Learn About Tax Reforms CTA ────────────────────────────────
          _buildLearnCTA(theme, isMobile),
          SizedBox(height: isMobile ? 20 : 24),

          // ─── Tax Category Results ─────────────────────────────────────────
          if (taxState.profile != null) ...[
            _buildTaxCategoryResults(theme, taxState, isMobile),
            SizedBox(height: isMobile ? 20 : 24),
          ],

          // ─── Inflation Chart ──────────────────────────────────────────────
          _buildInflationChart(theme, inflationState, isMobile),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Your Tax at a Glance',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.picture_as_pdf_outlined, size: 22),
                        tooltip: 'Download Tax Report',
                        onPressed: () => PdfService.exportTaxReport(profile),
                      ),
                    ],
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
              backgroundColor: theme.colorScheme.outlineVariant,
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

  Widget _buildMetricsGrid(ThemeData theme, TaxProfile profile) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _metricBox(
                theme,
                'Estimated Income',
                AppFormatter.nairaCompact(profile.annualGross),
                theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _metricBox(
                theme,
                'Tax Liability',
                AppFormatter.nairaCompact(profile.computedTax),
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

  // ─── Learn About Tax Reforms CTA ──────────────────────────────────────
  Widget _buildLearnCTA(ThemeData theme, bool isMobile) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.tertiary.withValues(alpha: 0.2),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiaryContainer,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.menu_book_outlined,
                            size: 22,
                            color: theme.colorScheme.tertiary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Learn About Tax Reforms',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Understand the new Nigeria Tax Act 2025 — PAYE, VAT, CIT, and more.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/learn'),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const Text('Explore'),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.menu_book_outlined,
                        size: 24,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Learn About Tax Reforms',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Understand the new Nigeria Tax Act 2025 — PAYE, VAT, CIT, and more.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/learn'),
                      icon: const Icon(Icons.arrow_forward, size: 18),
                      label: const Text('Explore'),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ─── Tax Category Results ──────────────────────────────────────────────
  Widget _buildTaxCategoryResults(ThemeData theme, TaxState taxState, bool isMobile) {
    final p = taxState.profile!;
    final annualGross = p.annualGross;
    final computedTax = p.computedTax;
    final netIncome = p.netIncome;
    final pension = p.pensionDeduction;
    final rentRelief = p.rentRelief;
    final vatPayable = p.monthlyIncome * 0.40 * 0.075;
    final payeRate = annualGross > 0 ? computedTax / annualGross : 0.0;
    final netRatio = annualGross > 0 ? netIncome / annualGross : 0.0;
    final pensionRatio = annualGross > 0 ? pension / annualGross : 0.0;
    final reliefRatio = rentRelief / 200000;
    final vatMaxRef = 50000.0;

    final citStatus = p.citExemption.startsWith('EXEMPT')
        ? 'Exempt'
        : p.citExemption.startsWith('TAXABLE_20')
            ? '20% Rate'
            : p.citExemption.startsWith('TAXABLE_30')
                ? '30% Rate'
                : 'No data';
    final citPercent = p.citExemption.startsWith('TAXABLE_20')
        ? '20%'
        : p.citExemption.startsWith('TAXABLE_30')
            ? '30%'
            : '0%';
    final citRatio = p.citExemption.startsWith('EXEMPT')
        ? 0.0
        : p.citExemption.startsWith('TAXABLE_20')
            ? 0.20
            : p.citExemption.startsWith('TAXABLE_30')
                ? 0.30
                : 0.0;

    final categories = [
      _TaxCategory(
        label: 'PAYE',
        ratio: payeRate.clamp(0.0, 1.0),
        percentage: '${(payeRate * 100).toStringAsFixed(1)}%',
        amount: AppFormatter.naira(computedTax),
        subtitle: 'of ${AppFormatter.nairaCompact(annualGross)} gross',
        color: theme.colorScheme.primary,
        bgColor: theme.colorScheme.primary.withValues(alpha: 0.12),
        icon: Icons.receipt_long_outlined,
        route: '/calculator',
      ),
      _TaxCategory(
        label: 'VAT',
        ratio: (vatPayable / vatMaxRef).clamp(0.0, 1.0),
        percentage: '7.5%',
        amount: AppFormatter.naira(vatPayable),
        subtitle: 'monthly on spending',
        color: theme.colorScheme.secondary,
        bgColor: theme.colorScheme.secondary.withValues(alpha: 0.12),
        icon: Icons.shopping_cart_outlined,
        route: '/calculator',
      ),
      _TaxCategory(
        label: 'CIT',
        ratio: citRatio,
        percentage: citPercent,
        amount: AppFormatter.naira(0),
        subtitle: citStatus,
        color: theme.colorScheme.tertiary,
        bgColor: theme.colorScheme.tertiary.withValues(alpha: 0.12),
        icon: Icons.business_outlined,
        route: '/calculator',
      ),
      _TaxCategory(
        label: 'Net Income',
        ratio: netRatio.clamp(0.0, 1.0),
        percentage: '${(netRatio * 100).toStringAsFixed(0)}%',
        amount: AppFormatter.naira(netIncome),
        subtitle: 'of ${AppFormatter.nairaCompact(annualGross)} gross',
        color: const Color(0xFF15803D),
        bgColor: const Color(0xFF15803D).withValues(alpha: 0.1),
        icon: Icons.account_balance_wallet_outlined,
        route: '/dashboard/analytics',
      ),
      _TaxCategory(
        label: 'Pension',
        ratio: pensionRatio.clamp(0.0, 1.0),
        percentage: '${(pensionRatio * 100).toStringAsFixed(0)}%',
        amount: AppFormatter.naira(pension),
        subtitle: '8% of gross',
        color: const Color(0xFFB45309),
        bgColor: const Color(0xFFB45309).withValues(alpha: 0.1),
        icon: Icons.savings_outlined,
        route: '/calculator',
      ),
      _TaxCategory(
        label: 'Relief',
        ratio: reliefRatio.clamp(0.0, 1.0),
        percentage: '${(reliefRatio * 100).toStringAsFixed(0)}%',
        amount: AppFormatter.naira(rentRelief),
        subtitle: 'max rent relief cap',
        color: const Color(0xFF7C3AED),
        bgColor: const Color(0xFF7C3AED).withValues(alpha: 0.1),
        icon: Icons.discount_outlined,
        route: '/calculator',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tax Breakdown',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = isMobile ? 2 : 3;
            final spacing = 12.0;
            final cardWidth = (constraints.maxWidth - (crossAxisCount - 1) * spacing) / crossAxisCount;
            final cardHeight = cardWidth * 1.35;
            final aspectRatio = cardWidth / cardHeight;

            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: aspectRatio,
              children: categories.map((cat) => _taxCategoryTile(theme, cat)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _taxCategoryTile(ThemeData theme, _TaxCategory cat) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final circleSize = (constraints.maxWidth * 0.38).clamp(32.0, 52.0);
        final labelSize = (constraints.maxWidth * 0.095).clamp(11.0, 14.0);
        final percentSize = (constraints.maxWidth * 0.085).clamp(9.0, 12.0);
        final amountSize = (constraints.maxWidth * 0.095).clamp(11.0, 14.0);
        final subtitleSize = (constraints.maxWidth * 0.075).clamp(9.0, 11.0);
        final strokeWidth = (circleSize * 0.09).clamp(3.0, 5.0);
        final verticalGap = (constraints.maxHeight * 0.04).clamp(2.0, 8.0);

        return InkWell(
          onTap: () => context.go(cat.route),
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
                Text(
                  cat.label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                    fontSize: labelSize,
                  ),
                ),
                SizedBox(height: verticalGap),
                SizedBox(
                  width: circleSize,
                  height: circleSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: circleSize,
                        height: circleSize,
                        child: CircularProgressIndicator(
                          value: cat.ratio,
                          strokeWidth: strokeWidth,
                          backgroundColor: cat.bgColor,
                          valueColor: AlwaysStoppedAnimation<Color>(cat.color),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Text(
                        cat.percentage,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: percentSize,
                          fontWeight: FontWeight.w700,
                          color: cat.color,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: verticalGap),
                Text(
                  cat.amount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: amountSize,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: verticalGap * 0.4),
                Text(
                  cat.subtitle,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: subtitleSize,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Inflation Chart ───────────────────────────────────────────────────
  Widget _buildInflationChart(ThemeData theme, InflationState state, bool isMobile) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Nigeria Inflation Rate',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  if (state.data.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Latest: ${state.data.last.value.toStringAsFixed(1)}%',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Consumer prices, annual % \u2014 World Bank',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 24),
              if (state.isLoading)
                const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (state.error != null && state.data.isEmpty)
                SizedBox(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_off_outlined, size: 40, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text(
                          'Unable to load inflation data',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: () => ref.read(inflationProvider.notifier).retry(),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 220,
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: state.data.isEmpty ? 10.0 : state.data.map((d) => d.value).reduce((a, b) => a > b ? a : b) * 1.2,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipItem: (group, groupIdx, rod, rodIdx) {
                            return BarTooltipItem(
                              '${state.data[group.x.toInt()].year}\n${rod.toY.toStringAsFixed(1)}%',
                              GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          },
                        ),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final idx = value.toInt();
                              if (idx < state.data.length) {
                                if (isMobile && idx % 2 != 0 && idx != state.data.length - 1) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${state.data[idx].year}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                            reservedSize: isMobile ? 36 : 32,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                '${value.toInt()}%',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 5,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(state.data.length, (i) {
                        final d = state.data[i];
                        final isLatest = i == state.data.length - 1;
                        return BarChartGroupData(
                          x: i,
                          barRods: [
                            BarChartRodData(
                              toY: d.value,
                              color: isLatest
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.primary.withValues(alpha: 0.7),
                              width: isMobile ? 20 : 28,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
            ],
          ),
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
            Flexible(
              child: Text(
                'Recent News: NTA 2025',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
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
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, idx) {
                final art = state.articles[idx];
                return _newsCard(theme, art);
              },
            ),
          ),
      ],
    );
  }

  Widget _newsCard(ThemeData theme, TaxArticle article) {
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

class _TaxCategory {
  final String label;
  final double ratio;
  final String percentage;
  final String amount;
  final String subtitle;
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String route;

  const _TaxCategory({
    required this.label,
    required this.ratio,
    required this.percentage,
    required this.amount,
    required this.subtitle,
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.route,
  });
}
