class AppConstants {
  AppConstants._();

  // ── API ────────────────────────────────────────────────────────────────────
  // Replace with your actual Express backend URL when deploying
  static const String apiBaseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator
  // static const String apiBaseUrl = 'http://localhost:3000/api/v1'; // Web/desktop

  // ── Supabase ───────────────────────────────────────────────────────────────
  // Replace with your actual Supabase project values
  static const String supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
  static const String supabaseAnonKey = 'YOUR_ANON_KEY';

  // ── Hive Box Names ─────────────────────────────────────────────────────────
  static const String taxProfileBox   = 'tax_profiles';
  static const String articlesBox     = 'tax_articles';
  static const String settingsBox     = 'app_settings';

  // ── SharedPreferences Keys ─────────────────────────────────────────────────
  static const String themeKey        = 'is_dark_mode';
  static const String biometricKey    = 'biometric_enabled';
  static const String onboardedKey    = 'has_onboarded';

  // ── App Metadata ────────────────────────────────────────────────────────────
  static const String appName         = 'NaijaTax Enlighten';
  static const String appVersion      = '1.0.0';

  // ── Layout Breakpoints ─────────────────────────────────────────────────────
  static const double mobileBreakpoint  = 600;
  static const double tabletBreakpoint  = 900;
  static const double desktopBreakpoint = 1280;
}
