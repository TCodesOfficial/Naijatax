import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tax_profile.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum TaxStatus { idle, loading, loaded, error }

class TaxState {
  final TaxStatus status;
  final TaxProfile? profile;
  final String? error;
  final List<TaxProfile> history;
  final bool historyLoading;

  const TaxState({
    this.status = TaxStatus.idle,
    this.profile,
    this.error,
    this.history = const [],
    this.historyLoading = false,
  });

  TaxState copyWith({
    TaxStatus? status,
    TaxProfile? profile,
    String? error,
    List<TaxProfile>? history,
    bool? historyLoading,
  }) =>
      TaxState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        error: error ?? this.error,
        history: history ?? this.history,
        historyLoading: historyLoading ?? this.historyLoading,
      );
}

class TaxNotifier extends Notifier<TaxState> {
  @override
  TaxState build() {
    final cached = StorageService.getLatestTaxProfile();
    if (cached != null) {
      return TaxState(status: TaxStatus.loaded, profile: TaxProfile.fromJson(cached));
    }
    return const TaxState();
  }

  Future<void> fetchFromServer() async {
    state = state.copyWith(status: TaxStatus.loading, error: null);
    try {
      final data = await ApiService.instance.getLatestTaxProfile();
      if (data != null) {
        final profile = TaxProfile.fromJson(data);
        await StorageService.saveTaxProfile(data);
        state = state.copyWith(status: TaxStatus.loaded, profile: profile);
      } else {
        state = state.copyWith(status: TaxStatus.idle);
      }
    } catch (e) {
      state = state.copyWith(status: TaxStatus.error, error: e.toString());
    }
  }

  /// Loads calculation history: server for authenticated users,
  /// local Hive fallback for guests / offline.
  Future<void> fetchHistory() async {
    state = state.copyWith(historyLoading: true);
    try {
      final data = await ApiService.instance.getTaxHistory();
      final items = data
          .map((e) => TaxProfile.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      state = state.copyWith(history: items, historyLoading: false);
    } catch (_) {
      final local = StorageService.getTaxCalculationHistory()
          .map((e) => TaxProfile.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      state = state.copyWith(history: local, historyLoading: false);
    }
  }

  Future<void> calculate({
    required double monthlyIncome,
    double rentPaid = 0,
    double pensionRate = 0.08,
    double turnover = 0,
    double assets = 0,
    double? flatRate,
    double? rentReliefRate,
  }) async {
    state = state.copyWith(status: TaxStatus.loading, error: null);
    try {
      final body = <String, dynamic>{
        'monthlyIncome': monthlyIncome,
        'rentPaid': rentPaid,
        'pensionRate': pensionRate,
        'turnover': turnover,
        'assets': assets,
        'isMonthly': true,
        if (flatRate != null) 'flatRate': flatRate,
        if (rentReliefRate != null) 'rentReliefRate': rentReliefRate,
      };
      final data = await ApiService.instance.calculateTax(body);
      final profile = TaxProfile.fromJson(data);
      await StorageService.saveTaxProfile(data);

      final historyEntry = Map<String, dynamic>.from(data as Map);
      historyEntry['createdAt'] = DateTime.now().toIso8601String();
      await StorageService.addTaxCalculationToHistory(historyEntry);

      state = state.copyWith(status: TaxStatus.loaded, profile: profile);
      unawaited(fetchHistory());
    } catch (e) {
      state = state.copyWith(status: TaxStatus.error, error: e.toString());
    }
  }

  void reset() {
    state = const TaxState();
    unawaited(fetchHistory());
  }
}

final taxProvider = NotifierProvider<TaxNotifier, TaxState>(TaxNotifier.new);
