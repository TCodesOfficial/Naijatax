import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/tax_profile.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum TaxStatus { idle, loading, loaded, error }

class TaxState {
  final TaxStatus status;
  final TaxProfile? profile;
  final String? error;
  final Map<String, dynamic>? parsedStatement;

  const TaxState({
    this.status = TaxStatus.idle,
    this.profile,
    this.error,
    this.parsedStatement,
  });

  TaxState copyWith({
    TaxStatus? status,
    TaxProfile? profile,
    String? error,
    Map<String, dynamic>? parsedStatement,
  }) =>
      TaxState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        error: error ?? this.error,
        parsedStatement: parsedStatement ?? this.parsedStatement,
      );
}

class TaxNotifier extends Notifier<TaxState> {
  @override
  TaxState build() {
    // Load cached profile for offline display
    final cached = StorageService.getLatestTaxProfile();
    if (cached != null) {
      return TaxState(status: TaxStatus.loaded, profile: TaxProfile.fromJson(cached));
    }
    return const TaxState();
  }

  Future<void> calculate({
    required double monthlyIncome,
    double rentPaid = 0,
    double pensionRate = 0.08,
    double turnover = 0,
    double assets = 0,
  }) async {
    state = state.copyWith(status: TaxStatus.loading, error: null);
    try {
      final data = await ApiService.instance.calculateTax({
        'monthlyIncome': monthlyIncome,
        'rentPaid': rentPaid,
        'pensionRate': pensionRate,
        'turnover': turnover,
        'assets': assets,
        'isMonthly': true,
      });
      final profile = TaxProfile.fromJson(data);
      // Cache for offline usage
      await StorageService.saveTaxProfile(data);
      state = state.copyWith(status: TaxStatus.loaded, profile: profile);
    } catch (e) {
      state = state.copyWith(status: TaxStatus.error, error: e.toString());
    }
  }

  void reset() => state = const TaxState();
}

final taxProvider = NotifierProvider<TaxNotifier, TaxState>(TaxNotifier.new);
