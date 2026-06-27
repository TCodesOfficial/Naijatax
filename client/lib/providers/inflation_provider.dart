import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/inflation_data.dart';
import '../services/inflation_service.dart';

class InflationState {
  final bool isLoading;
  final List<InflationData> data;
  final String? error;

  const InflationState({
    this.isLoading = false,
    this.data = const [],
    this.error,
  });
}

class InflationNotifier extends Notifier<InflationState> {
  @override
  InflationState build() => const InflationState();

  Future<void> fetch() async {
    state = const InflationState(isLoading: true);
    try {
      final data = await InflationService.fetchInflation(years: 10);
      state = InflationState(data: data);
    } catch (e) {
      state = InflationState(error: e.toString());
    }
  }

  Future<void> retry() async => fetch();
}

final inflationProvider =
    NotifierProvider<InflationNotifier, InflationState>(InflationNotifier.new);
