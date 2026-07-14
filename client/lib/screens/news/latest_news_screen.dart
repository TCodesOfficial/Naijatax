import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/article_model.dart';
import '../../providers/article_provider.dart';

class LatestNewsScreen extends ConsumerStatefulWidget {
  const LatestNewsScreen({super.key});

  @override
  ConsumerState<LatestNewsScreen> createState() => _LatestNewsScreenState();
}

class _LatestNewsScreenState extends ConsumerState<LatestNewsScreen> {
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(articlesProvider.notifier).fetchArticles());
  }

  List<String> get filters => ['All', 'NTA_2025', 'PAYE', 'CIT', 'VAT', 'COMPLIANCE'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final articlesState = ref.watch(articlesProvider);

    final filteredArticles = _selectedFilter == 'All'
        ? articlesState.articles
        : articlesState.articles.where((a) => a.category == _selectedFilter).toList();

    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tax News & Updates',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (_, _) => const SizedBox(width: 8),
              itemBuilder: (context, idx) {
                final f = filters[idx];
                final isActive = _selectedFilter == f;
                return ChoiceChip(
                  label: Text(f),
                  selected: isActive,
                  onSelected: (_) {
                    setState(() => _selectedFilter = f);
                    ref.read(articlesProvider.notifier).setCategory(
                      _selectedFilter == 'All' ? null : _selectedFilter,
                    );
                  },
                  selectedColor: theme.colorScheme.primary,
                  labelStyle: TextStyle(
                    color: isActive ? Colors.white : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          if (articlesState.isLoading)
            const Center(child: Padding(
              padding: EdgeInsets.all(40),
              child: CircularProgressIndicator(),
            ))
          else if (filteredArticles.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No articles available.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            )
          else ...[
            // Featured article
            if (filteredArticles.isNotEmpty)
              _featuredCard(theme, filteredArticles.first, isMobile),
            const SizedBox(height: 20),
            // News grid
            isMobile
                ? Column(
                    children: filteredArticles.skip(1).map(
                      (a) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _newsCard(theme, a),
                      ),
                    ).toList(),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 900 ? 3 : 2;
                      final childAspectRatio = constraints.maxWidth > 900 ? 1.3 : 1.15;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: filteredArticles.skip(1).length,
                        itemBuilder: (context, index) {
                          final article = filteredArticles.skip(1).elementAt(index);
                          return _newsCard(theme, article);
                        },
                      );
                    },
                  ),
          ],
        ],
      ),
    );
  }

  Widget _featuredCard(ThemeData theme, TaxArticle article, bool isMobile) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _featuredBadge(theme, article),
                    const SizedBox(height: 12),
                    Text(
                      article.title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.summary,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _featuredBadge(theme, article),
                          const SizedBox(height: 12),
                          Text(
                            article.title,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            article.summary,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.article_outlined,
                            size: 60,
                            color: theme.colorScheme.primary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _featuredBadge(ThemeData theme, dynamic article) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFB91C1C),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Breaking',
            style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          article.source,
          style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _newsCard(ThemeData theme, TaxArticle article) {
    return Card(
      child: InkWell(
        onTap: () {
          if (article.url != null && article.url.toString().isNotEmpty) {
            launchUrl(Uri.parse(article.url.toString()));
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  article.source,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                article.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}