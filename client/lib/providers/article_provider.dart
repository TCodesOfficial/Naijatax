import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/article_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class ArticlesState {
  final bool isLoading;
  final List<TaxArticle> articles;
  final String? selectedCategory;
  final String? error;

  const ArticlesState({
    this.isLoading = false,
    this.articles = const [],
    this.selectedCategory,
    this.error,
  });

  ArticlesState copyWith({
    bool? isLoading,
    List<TaxArticle>? articles,
    String? selectedCategory,
    String? error,
    bool clearError = false,
  }) =>
      ArticlesState(
        isLoading: isLoading ?? this.isLoading,
        articles: articles ?? this.articles,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        error: clearError ? null : (error ?? this.error),
      );
}

class ArticlesNotifier extends Notifier<ArticlesState> {
  @override
  ArticlesState build() {
    final cached = StorageService.getCachedArticles();
    final List<TaxArticle> cachedList = cached != null
        ? cached.map((e) => TaxArticle.fromJson(e)).toList()
        : [];
    return ArticlesState(articles: cachedList);
  }

  Future<void> fetchArticles({String? category}) async {
    state = state.copyWith(isLoading: true, clearError: true, selectedCategory: category);
    try {
      final List<dynamic> data = await ApiService.instance.getPublicArticles(category: category);
      final list = data.map((e) => TaxArticle.fromJson(e as Map<String, dynamic>)).toList();
      // Cache only the unfiltered list — persisting a category subset made
      // the home feed shrink permanently after browsing a filter.
      if (category == null) {
        await StorageService.saveArticles(
            data.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      }
      state = state.copyWith(isLoading: false, articles: list);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
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
