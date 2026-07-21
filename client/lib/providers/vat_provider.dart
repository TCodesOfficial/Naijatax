import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/api_service.dart';

class VatItem {
  final String id;
  final String name;
  final String category;
  final String status;
  final double rate;

  const VatItem({
    required this.id,
    required this.name,
    required this.category,
    required this.status,
    required this.rate,
  });

  factory VatItem.fromJson(Map<String, dynamic> json) => VatItem(
        id: json['id'] as String,
        name: json['name'] as String,
        category: json['category'] as String,
        status: json['status'] as String,
        rate: double.tryParse(json['rate'].toString()) ?? 0.0,
      );
}

enum VatFilter { all, standard, zeroRated, exempt }

class VatState {
  final List<VatItem> items;
  final bool isLoading;
  final String? error;
  final VatFilter filter;
  final String searchQuery;

  const VatState({
    this.items = const [],
    this.isLoading = false,
    this.error,
    this.filter = VatFilter.all,
    this.searchQuery = '',
  });

  VatState copyWith({
    List<VatItem>? items,
    bool? isLoading,
    String? error,
    VatFilter? filter,
    String? searchQuery,
  }) =>
      VatState(
        items: items ?? this.items,
        isLoading: isLoading ?? this.isLoading,
        error: error ?? this.error,
        filter: filter ?? this.filter,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  List<VatItem> get filteredItems {
    switch (filter) {
      case VatFilter.standard:
        return items.where((i) => i.status == 'STANDARD').toList();
      case VatFilter.zeroRated:
        return items.where((i) => i.status == 'ZERO_RATED').toList();
      case VatFilter.exempt:
        return items.where((i) => i.status == 'EXEMPT').toList();
      case VatFilter.all:
        return items;
    }
  }
}

class VatNotifier extends StateNotifier<VatState> {
  bool _loaded = false;

  VatNotifier() : super(const VatState());

  Future<void> fetchIfNeeded() async {
    if (_loaded && state.items.isNotEmpty) return;
    await fetchItems();
  }

  Future<void> fetchItems({String? query, String? status}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final res = await ApiService.instance.searchVat(query: query, status: status);
      final items = res.map((e) => VatItem.fromJson(e as Map<String, dynamic>)).toList();
      state = state.copyWith(items: items, isLoading: false);
      _loaded = true;
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void setFilter(VatFilter filter) {
    state = state.copyWith(filter: filter);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchItems(query: query.isNotEmpty ? query : null);
  }
}

final vatProvider = StateNotifierProvider<VatNotifier, VatState>((ref) {
  return VatNotifier();
});
