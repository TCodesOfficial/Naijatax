import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    await Hive.openBox('tax_profiles');
    await Hive.openBox('tax_articles');
    await Hive.openBox('app_settings');
    _initialized = true;
  }

  // ── Tax Profile Cache ────────────────────────────────────────────────────
  static Future<void> saveTaxProfile(Map<String, dynamic> profile) async {
    final box = Hive.box('tax_profiles');
    await box.put('latest', profile);
  }

  static Map<String, dynamic>? getLatestTaxProfile() {
    final box = Hive.box('tax_profiles');
    return box.get('latest') as Map<String, dynamic>?;
  }

  // ── Articles Cache ───────────────────────────────────────────────────────
  static Future<void> saveArticles(List<Map<String, dynamic>> articles) async {
    final box = Hive.box('tax_articles');
    await box.put('cached_articles', articles);
  }

  static List<Map<String, dynamic>>? getCachedArticles() {
    final box = Hive.box('tax_articles');
    final raw = box.get('cached_articles');
    if (raw == null) return null;
    return (raw as List).map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  // ── App Settings ─────────────────────────────────────────────────────────
  static Future<void> setSetting(String key, dynamic value) async {
    final box = Hive.box('app_settings');
    await box.put(key, value);
  }

  static T? getSetting<T>(String key) {
    final box = Hive.box('app_settings');
    return box.get(key) as T?;
  }
}
