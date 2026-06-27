import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/dummy/dev_data.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ArticlesState {
  final bool isLoading;
  final List<TaxArticle> articles;
  final Map<String, dynamic> metrics;
  final String? error;

  const ArticlesState({
    this.isLoading = false,
    this.articles = const [],
    this.metrics = const {},
    this.error,
  });

  ArticlesState copyWith({
    bool? isLoading,
    List<TaxArticle>? articles,
    Map<String, dynamic>? metrics,
    String? error,
  }) =>
      ArticlesState(
        isLoading: isLoading ?? this.isLoading,
        articles: articles ?? this.articles,
        metrics: metrics ?? this.metrics,
        error: error ?? this.error,
      );
}

class ArticlesNotifier extends Notifier<ArticlesState> {
  @override
  ArticlesState build() {
    // Load cached articles for offline access
    final cached = StorageService.getCachedArticles();
    final List<TaxArticle> cachedList = cached != null
        ? cached.map((e) => TaxArticle.fromJson(e)).toList()
        : [];
    // If no cached data, use dev data so dashboard always has content
    return ArticlesState(
      articles: cachedList.isNotEmpty ? cachedList : DevData.articles,
      metrics: DevData.metrics,
    );
  }

  Future<void> fetchArticles() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final List<dynamic> data = await ApiService.instance.getArticles();
      final list = data.map((e) => TaxArticle.fromJson(e as Map<String, dynamic>)).toList();
      
      // Save raw map data to cache
      await StorageService.saveArticles(data.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      
      state = state.copyWith(isLoading: false, articles: list);
    } catch (e) {
      // API unavailable — use dev data
      final devArticles = DevData.articles;
      await StorageService.saveArticles(devArticles.map((a) => a.toJson()).toList());
      state = state.copyWith(isLoading: false, articles: devArticles);
    }
  }

  Future<void> fetchMetrics() async {
    try {
      final metricsData = await ApiService.instance.getEconomicMetrics();
      state = state.copyWith(metrics: metricsData);
    } catch (_) {
      // API unavailable — use dev data
      state = state.copyWith(metrics: DevData.metrics);
    }
  }
}

final articlesProvider = NotifierProvider<ArticlesNotifier, ArticlesState>(ArticlesNotifier.new);
