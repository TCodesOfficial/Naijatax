class TaxBreakdown {
  final String bracket;
  final double rate;
  final double taxableAmount;
  final double tax;

  const TaxBreakdown({
    required this.bracket,
    required this.rate,
    required this.taxableAmount,
    required this.tax,
  });

  factory TaxBreakdown.fromJson(Map<String, dynamic> json) => TaxBreakdown(
        bracket: json['bracket'] as String,
        rate: (json['rate'] as num).toDouble(),
        taxableAmount: (json['taxableAmount'] as num).toDouble(),
        tax: (json['tax'] as num).toDouble(),
      );
}

class TaxProfile {
  final double monthlyIncome;
  final double annualGross;
  final double pensionDeduction;
  final double rentRelief;
  final double taxableIncome;
  final double computedTax;
  final double netIncome;
  final bool isExempt;
  final String citExemption;
  final double savings;
  final List<TaxBreakdown> breakdown;

  const TaxProfile({
    required this.monthlyIncome,
    required this.annualGross,
    required this.pensionDeduction,
    required this.rentRelief,
    required this.taxableIncome,
    required this.computedTax,
    required this.netIncome,
    required this.isExempt,
    required this.citExemption,
    required this.savings,
    required this.breakdown,
  });

  factory TaxProfile.fromJson(Map<String, dynamic> json) => TaxProfile(
        monthlyIncome: (json['monthlyIncome'] as num).toDouble(),
        annualGross: (json['annualGross'] as num).toDouble(),
        pensionDeduction: (json['pensionDeduction'] as num).toDouble(),
        rentRelief: (json['rentRelief'] as num).toDouble(),
        taxableIncome: (json['taxableIncome'] as num).toDouble(),
        computedTax: (json['computedTax'] as num).toDouble(),
        netIncome: (json['netIncome'] as num).toDouble(),
        isExempt: json['isExempt'] as bool,
        citExemption: json['citExemption'] as String,
        savings: (json['savings'] as num).toDouble(),
        breakdown: (json['breakdown'] as List)
            .map((e) => TaxBreakdown.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  /// Effective tax rate as a percentage
  double get effectiveTaxRate =>
      annualGross > 0 ? (computedTax / annualGross) * 100 : 0;

  /// Net income as a percentage of gross (for pie chart)
  double get netIncomePercent =>
      annualGross > 0 ? (netIncome / annualGross) * 100 : 0;

  double get taxPercent =>
      annualGross > 0 ? (computedTax / annualGross) * 100 : 0;

  double get pensionPercent =>
      annualGross > 0 ? (pensionDeduction / annualGross) * 100 : 0;
}
