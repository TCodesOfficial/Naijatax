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

  static String naira(double v) => _nairaFull.format(v);

  /// Two-decimal naira (kobo-precision figures).
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

  /// Short/rounded naira for dense UI: ₦1.8M / ₦250K / ₦900
  static String nairaShort(double v) {
    if (v >= 1000000) return '\u20A6${(v / 1000000).toStringAsFixed(1)}M';
    if (v >= 1000) return '\u20A6${(v / 1000).toStringAsFixed(0)}K';
    return '\u20A6${v.toStringAsFixed(0)}';
  }

  /// Relative time such as `3h ago` / `Just now`.
  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 7) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }
}
