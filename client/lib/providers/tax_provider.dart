import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/dummy/dev_data.dart';
import '../models/tax_profile.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

enum TaxStatus { idle, loading, loaded, error }

class TaxState {
  final TaxStatus status;
  final TaxProfile? profile;
  final String? error;

  const TaxState({
    this.status = TaxStatus.idle,
    this.profile,
    this.error,
  });

  TaxState copyWith({
    TaxStatus? status,
    TaxProfile? profile,
    String? error,
  }) =>
      TaxState(
        status: status ?? this.status,
        profile: profile ?? this.profile,
        error: error ?? this.error,
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
    // No cached data — load dev data so dashboard always has content
    return TaxState(status: TaxStatus.loaded, profile: DevData.taxProfile);
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
      // API unavailable — use dev data
      await StorageService.saveTaxProfile({
        'monthlyIncome': DevData.taxProfile.monthlyIncome,
        'annualGross': DevData.taxProfile.annualGross,
        'pensionDeduction': DevData.taxProfile.pensionDeduction,
        'rentRelief': DevData.taxProfile.rentRelief,
        'taxableIncome': DevData.taxProfile.taxableIncome,
        'computedTax': DevData.taxProfile.computedTax,
        'netIncome': DevData.taxProfile.netIncome,
        'isExempt': DevData.taxProfile.isExempt,
        'citExemption': DevData.taxProfile.citExemption,
        'savings': DevData.taxProfile.savings,
        'breakdown': DevData.taxProfile.breakdown.map((b) => {
          'bracket': b.bracket,
          'rate': b.rate,
          'taxableAmount': b.taxableAmount,
          'tax': b.tax,
        }).toList(),
      });
      state = state.copyWith(status: TaxStatus.loaded, profile: DevData.taxProfile);
    }
  }

  void reset() => state = const TaxState();
}

final taxProvider = NotifierProvider<TaxNotifier, TaxState>(TaxNotifier.new);
