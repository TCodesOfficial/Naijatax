class InflationData {
  final int year;
  final double value;

  const InflationData({
    required this.year,
    required this.value,
  });

  factory InflationData.fromJson(Map<String, dynamic> json) => InflationData(
        year: int.parse(json['date'] as String),
        value: (json['value'] as num?)?.toDouble() ?? 0.0,
      );
}
