import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ArticlesState {
  final bool isLoading;
  final List<TaxArticle> articles;
  final String? selectedCategory;
  final Map<String, dynamic> metrics;
  final String? error;

  const ArticlesState({
    this.isLoading = false,
    this.articles = const [],
    this.selectedCategory,
    this.metrics = const {},
    this.error,
  });

  ArticlesState copyWith({
    bool? isLoading,
    List<TaxArticle>? articles,
    String? selectedCategory,
    Map<String, dynamic>? metrics,
    String? error,
  }) =>
      ArticlesState(
        isLoading: isLoading ?? this.isLoading,
        articles: articles ?? this.articles,
        selectedCategory: selectedCategory ?? this.selectedCategory,
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
    // If no cached data, return empty state
    return ArticlesState(
      articles: cachedList,
    );
  }

  Future<void> fetchArticles({String? category}) async {
    state = state.copyWith(isLoading: true, error: null, selectedCategory: category);
    try {
      final List<dynamic> data = await ApiService.instance.getPublicArticles(category: category);
      final list = data.map((e) => TaxArticle.fromJson(e as Map<String, dynamic>)).toList();
      
      // Save raw map data to cache
      await StorageService.saveArticles(data.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      
      state = state.copyWith(isLoading: false, articles: list);
    } catch (e) {
      // API unavailable — keep existing data
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> fetchMetrics() async {
    try {
      final metricsData = await ApiService.instance.getEconomicMetrics();
      state = state.copyWith(metrics: metricsData);
    } catch (_) {
      // API unavailable — keep existing metrics
    }
  }

  void setCategory(String? category) {
    state = state.copyWith(selectedCategory: category);
    if (category != null) {
      fetchArticles(category: category);
    } else {
      fetchArticles();
    }
  }
}

final articlesProvider = NotifierProvider<ArticlesNotifier, ArticlesState>(ArticlesNotifier.new);
