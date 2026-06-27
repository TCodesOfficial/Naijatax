import 'package:dio/dio.dart';
import '../models/inflation_data.dart';

class InflationService {
  static const _baseUrl =
      'https://api.worldbank.org/v2/country/NGA/indicator/FP.CPI.TOTL.ZG';

  static final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Accept': 'application/json'},
  ));

  static Future<List<InflationData>> fetchInflation({int years = 10}) async {
    final endYear = DateTime.now().year;
    final startYear = endYear - years + 1;
    final url = '$_baseUrl?format=json&per_page=$years&date=$startYear:$endYear';

    final response = await _dio.get(url);
    final parsed = response.data;

    if (parsed is List && parsed.length >= 2) {
      final dataList = parsed[1];
      if (dataList is List) {
        final items = dataList
            .map((e) => InflationData.fromJson(e as Map<String, dynamic>))
            .where((d) => d.value > 0)
            .toList()
          ..sort((a, b) => a.year.compareTo(b.year));
        return items;
      }
    }
    return [];
  }
}
