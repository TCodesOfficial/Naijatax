import 'package:intl/intl.dart';

class AppFormatter {
  AppFormatter._();

  static final _nairaFull = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '\u20A6',
    decimalDigits: 0,
  );

  static final _nairaDecimal = NumberFormat.currency(
    locale: 'en_NG',
    symbol: '\u20A6',
    decimalDigits: 2,
  );

  static final _percent = NumberFormat.decimalPattern('en');

  static String naira(double v) => _nairaFull.format(v);

  static String nairaDecimal(double v) => _nairaDecimal.format(v);

  static String nairaCompact(double v) {
    if (v >= 1000000000) {
      return '\u20A6${(v / 1000000000).toStringAsFixed(1)}B';
    }
    if (v >= 1000000) {
      return '\u20A6${(v / 1000000).toStringAsFixed(1)}M';
    }
    return _nairaFull.format(v);
  }

  static String percentValue(double v) => '${_percent.format(v)}%';
}
