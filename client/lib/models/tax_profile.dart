double _parseNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

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
        bracket: (json['bracket'] as String?) ?? '',
        rate: _parseNum(json['rate']),
        taxableAmount: _parseNum(json['taxableAmount']),
        tax: _parseNum(json['tax']),
      );
}

class TaxProfile {
  final String? id;
  final DateTime? createdAt;
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
    this.id,
    this.createdAt,
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
        id: json['id'] as String?,
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        monthlyIncome: _parseNum(json['monthlyIncome']),
        annualGross: _parseNum(json['annualGross']),
        pensionDeduction: _parseNum(json['pensionDeduction']),
        rentRelief: _parseNum(json['rentRelief']),
        taxableIncome: _parseNum(json['taxableIncome']),
        computedTax: _parseNum(json['computedTax']),
        netIncome: _parseNum(json['netIncome']),
        isExempt: json['isExempt'] as bool? ?? false,
        citExemption: (json['citExemption'] as String?) ?? 'N/A',
        savings: _parseNum(json['savings']),
        breakdown: (json['breakdown'] as List?)
                ?.map((e) => TaxBreakdown.fromJson(Map<String, dynamic>.from(e as Map)))
                .toList() ??
            [],
      );

  /// Effective tax rate as a percentage
  double get effectiveTaxRate =>
      annualGross > 0 ? (computedTax / annualGross) * 100 : 0;
}
