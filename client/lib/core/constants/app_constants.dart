import 'package:flutter/foundation.dart';

class AppConstants {

AppConstants._();

  static const String _envApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  // ── API ───────────────────────────────────────────────────────────────
  /// Release builds MUST receive `--dart-define=API_BASE_URL=...` (or
  /// `-from-file`). Cleartext http:// and localhost/10.0.2.2 fallbacks are
  /// blocked on real devices, so they silently produced a dead app — in
  /// release we return '' instead and [MyApp] shows a configuration error.
  static String get apiBaseUrl {
    if (_envApiBaseUrl.isNotEmpty) return _envApiBaseUrl;

    if (kReleaseMode) return '';

    if (kIsWeb) {
      return 'http://localhost:3000/api/v1';
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return 'http://localhost:3000/api/v1';
      case TargetPlatform.android:
        return 'http://10.0.2.2:3000/api/v1';
      default:
        return 'http://localhost:3000/api/v1';
    }
  }

  // ── Supabase ──────────────────────────────────────────────────────────
  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );
  
  // ── Google Sign-In ────────────────────────────────────────────────────
  static const String googleWebClientId = String.fromEnvironment(
    'GOOGLE_WEB_CLIENT_ID',
  );
  // ── Hive Box Names ────────────────────────────────────────────────────
  static const String taxProfileBox = 'tax_profiles';
  static const String articlesBox = 'tax_articles';
  static const String settingsBox = 'app_settings';

  // ── SharedPreferences Keys ────────────────────────────────────────────
  static const String biometricKey = 'biometric_enabled';

  // ── App Metadata ──────────────────────────────────────────────────────
  static const String appName = 'NaijaTax Enlighten';
  static const String appShortName = 'NaijaTax';

  // ── Assets ────────────────────────────────────────────────────────────
  static const String logoSquareAsset =
      'assets/images/NaijaTax_short_logo_main.png';
  static const String logoLongAsset = 'assets/images/logo_long.png';

  // ── Layout Breakpoints ────────────────────────────────────────────────
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
}
