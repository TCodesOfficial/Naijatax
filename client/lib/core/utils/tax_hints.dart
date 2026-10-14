/// Client-side mirror of the server's tax logic (`server/src/services/tax.service.ts`).
/// Used for live per-field hints and the percentage-mode instant estimate.
///
/// The server remains authoritative: every "Calculate" still hits `/tax/calculate`.
class TaxBand {
  final String label;
  final double rate;
  final double width;

  const TaxBand({
    required this.label,
    required this.rate,
    required this.width,
  });
}

/// Progressive brackets from the Nigeria Tax Act (server-authoritative widths).
const List<TaxBand> kNtaBands = [
  TaxBand(label: 'First ₦800k', rate: 0.00, width: 800000),
  TaxBand(label: '₦800k – ₦3M', rate: 0.15, width: 2200000),
  TaxBand(label: '₦3M – ₦12M', rate: 0.18, width: 9000000),
  TaxBand(label: '₦12M – ₦25M', rate: 0.21, width: 13000000),
  TaxBand(label: '₦25M – ₦50M', rate: 0.23, width: 25000000),
  TaxBand(label: 'Above ₦50M', rate: 0.25, width: double.infinity),
];

class FlatEstimate {
  final double taxableIncome;
  final double computedTax;
  final double netIncome;
  final double pensionDeduction;
  final double rentRelief;
  final double effectiveRate;

  const FlatEstimate({
    required this.taxableIncome,
    required this.computedTax,
    required this.netIncome,
    required this.pensionDeduction,
    required this.rentRelief,
    required this.effectiveRate,
  });
}

class TaxHints {
  const TaxHints._();

  static const double defaultPensionRate = 0.08;
  static const double defaultRentReliefRate = 0.20;
  static const double rentReliefCap = 500000;
  static const double citSmallTurnoverCap = 100000000;
  static const double citSmallAssetsCap = 250000000;
  static const double citMediumTurnoverCap = 500000000;

  /// Parses user input, tolerating thousands separators.
  static double parseAmount(String? text) =>
      double.tryParse((text ?? '').replaceAll(',', '')) ?? 0;

  /// 20% of rent paid, capped at ₦500,000.
  static double rentRelief(double rentPaid, {double rate = defaultRentReliefRate}) {
    final relief = rentPaid * rate;
    return relief > rentReliefCap ? rentReliefCap : relief;
  }

  static double pensionDeduction(double annualGross, double rate) =>
      annualGross * rate;

  static double taxableIncome({
    required double annualGross,
    required double pension,
    required double relief,
  }) {
    final taxable = annualGross - pension - relief;
    return taxable > 0 ? taxable : 0;
  }

  /// The band that contains the last naira of taxable income (marginal band).
  static TaxBand? marginalBand(double taxable) {
    if (taxable <= 0) return null;
    double remaining = taxable;
    for (final band in kNtaBands) {
      if (remaining <= band.width) return band;
      remaining -= band.width;
    }
    return kNtaBands.last;
  }

  /// 'Exempt', '15%', '18%', '21%', '23%' or '25%'.
  static String marginalLabel(double taxable) {
    final band = marginalBand(taxable);
    if (band == null || band.rate == 0) return 'Exempt';
    return '${(band.rate * 100).toStringAsFixed(0)}%';
  }

  /// Compact naira for hint pills: ₦1.8M / ₦250k / ₦900
  static String compactNaira(double value) {
    if (value >= 1000000) return '₦${_trim(value / 1000000)}M';
    if (value >= 1000) return '₦${_trim(value / 1000)}k';
    return '₦${value.toStringAsFixed(0)}';
  }

  static String _trim(double v) {
    final s = v.toStringAsFixed(1);
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }

  /// CIT classification for business inputs.
  /// Returns 'N/A', 'EXEMPT', '20%' or '30%'.
  static String citRate(double turnover, double assets) {
    if (turnover <= 0 && assets <= 0) return 'N/A';
    if (turnover <= citSmallTurnoverCap && assets <= citSmallAssetsCap) {
      return 'EXEMPT';
    }
    if (turnover <= citMediumTurnoverCap) return '20%';
    return '30%';
  }

  /// Instant client-side estimate for percentage mode.
  /// Mirrors the server's deduction logic with a flat income-tax rate.
  static FlatEstimate flatEstimate({
    required double annualGross,
    required double pensionRate,
    required double rentPaid,
    double rentReliefRate = defaultRentReliefRate,
    required double flatRate,
  }) {
    final pension = pensionDeduction(annualGross, pensionRate);
    final relief = rentRelief(rentPaid, rate: rentReliefRate);
    final taxable = taxableIncome(
      annualGross: annualGross,
      pension: pension,
      relief: relief,
    );
    final tax = taxable * flatRate;
    return FlatEstimate(
      taxableIncome: taxable,
      computedTax: tax,
      netIncome: annualGross - tax - pension,
      pensionDeduction: pension,
      rentRelief: relief,
      effectiveRate: annualGross > 0 ? (tax / annualGross) * 100 : 0,
    );
  }
}
