import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/article_provider.dart';
import '../../models/article_model.dart';

class TaxEducationScreen extends ConsumerStatefulWidget {
  const TaxEducationScreen({super.key});

  @override
  ConsumerState<TaxEducationScreen> createState() => _TaxEducationScreenState();
}

class _TaxEducationScreenState extends ConsumerState<TaxEducationScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(articlesProvider.notifier).fetchArticles());
  }

  void _showArticleDetails(ThemeData theme, TaxArticle art) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(art.source),
            actions: [
              if (art.url != null)
                IconButton(
                  icon: const Icon(Icons.open_in_browser),
                  onPressed: () async {
                    final uri = Uri.tryParse(art.url!);
                    if (uri != null) await launchUrl(uri);
                  },
                ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  art.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Published: ${DateFormat.yMMMd().format(art.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const Divider(height: 32),
                Text(
                  art.content,
                  style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final articlesState = ref.watch(articlesProvider);

    return Scaffold(
      body: articlesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : articlesState.articles.isEmpty
              ? const Center(child: Text('No educational articles available right now.'))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: articlesState.articles.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, idx) {
                    final art = articlesState.articles[idx];
                    return Card(
                      child: InkWell(
                        onTap: () => _showArticleDetails(theme, art),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      art.source,
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    DateFormat.yMMMd().format(art.createdAt),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                art.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                art.summary,
                                style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 14),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
