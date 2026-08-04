import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'theme_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color textColor, Color subtleColor) => TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
            fontSize: 48,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.96,
            color: textColor),
        headlineLarge: GoogleFonts.plusJakartaSans(
            fontSize: 32, fontWeight: FontWeight.w700, color: textColor),
        headlineMedium: GoogleFonts.plusJakartaSans(
            fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
        headlineSmall: GoogleFonts.plusJakartaSans(
            fontSize: 20, fontWeight: FontWeight.w600, color: textColor),
        titleLarge: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.w600, color: textColor),
        titleMedium: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w500, color: textColor),
        titleSmall: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w500, color: textColor),
        bodyLarge: GoogleFonts.inter(
            fontSize: 18, fontWeight: FontWeight.w400, color: textColor),
        bodyMedium: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w400, color: textColor),
        bodySmall: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: subtleColor),
        labelSmall: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: subtleColor),
      );

  // ─── Light Theme ─────────────────────────────────────────────────────────
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: AppColors.white,
          primaryContainer: AppColors.primaryFixed,
          onPrimaryContainer: AppColors.primary,
          secondary: AppColors.secondary,
          onSecondary: AppColors.white,
          secondaryContainer: Color(0xFFD0E4FF),
          onSecondaryContainer: Color(0xFF001C39),
          tertiary: AppColors.tertiary,
          onTertiary: AppColors.white,
          tertiaryContainer: Color(0xFFB7F0D4),
          onTertiaryContainer: Color(0xFF002114),
          error: AppColors.error,
          onError: AppColors.white,
          errorContainer: Color(0xFFFFDAD6),
          onErrorContainer: Color(0xFF410002),
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          surfaceContainerLowest: AppColors.white,
          surfaceContainerLow: AppColors.surfaceLow,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerHigh: AppColors.surfaceHigh,
          surfaceContainerHighest: AppColors.surfaceHighest,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          inverseSurface: AppColors.darkSurface,
          onInverseSurface: AppColors.darkTextPrimary,
          inversePrimary: AppColors.darkPrimary,
        ),
        textTheme: _textTheme(AppColors.onSurface, AppColors.onSurfaceVariant),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.outlineVariant)),
          color: AppColors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLow,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.outlineVariant)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.outlineVariant)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.error)),
          labelStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
          hintStyle: GoogleFonts.inter(color: AppColors.outline),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.onSurfaceVariant,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
        dividerTheme: const DividerThemeData(
            color: AppColors.outlineVariant, thickness: 1, space: 1),
        scaffoldBackgroundColor: AppColors.background,
      );

  // ─── Dark Theme ──────────────────────────────────────────────────────────
  // Pure blue-navy tinted dark theme. Every surface, border, and accent lives
  // on the blue spectrum — no purple drift, no grey contamination.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          // ── Primary (bright sky blue) ──────────────────────────────────
          primary: AppColors.darkPrimary,
          onPrimary: AppColors.darkOnPrimary,
          primaryContainer: AppColors.darkPrimaryContainer,
          onPrimaryContainer: AppColors.darkOnPrimaryContainer,

          // ── Secondary (lighter sky blue, good for badges / chips) ──────
          secondary: AppColors.darkSecondary,
          onSecondary: AppColors.darkOnSecondary,
          secondaryContainer: AppColors.darkSecondaryContainer,
          onSecondaryContainer: AppColors.darkOnSecondaryContainer,

          // ── Tertiary (cyan accent — complementary to blue palette) ─────
          tertiary: AppColors.darkTertiary,
          onTertiary: AppColors.darkOnTertiary,
          tertiaryContainer: AppColors.darkTertiaryContainer,
          onTertiaryContainer: AppColors.darkOnTertiaryContainer,

          // ── Error ──────────────────────────────────────────────────────
          error: AppColors.darkError,
          onError: AppColors.darkOnError,
          errorContainer: AppColors.darkErrorContainer,
          onErrorContainer: AppColors.darkOnErrorContainer,

          // ── Surfaces (all deep blue-navy) ──────────────────────────────
          surface: AppColors.darkSurface,
          onSurface: AppColors.darkTextPrimary,
          surfaceContainerLowest: AppColors.darkBackground,
          surfaceContainerLow: AppColors.darkSurfaceLow,
          surfaceContainer: AppColors.darkSurfaceContainer,
          surfaceContainerHigh: AppColors.darkSurfaceHigh,
          surfaceContainerHighest: AppColors.darkSurfaceHighest,

          // ── Outlines ──────────────────────────────────────────────────
          outline: AppColors.darkOutline,
          outlineVariant: AppColors.darkBorder,

          // ── Inverse (for snackbars, tooltips) ─────────────────────────
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.inverseOnSurface,
          inversePrimary: AppColors.primary,
        ),
        textTheme: _textTheme(AppColors.darkTextPrimary, AppColors.darkTextSubtle),

        // ── AppBar ────────────────────────────────────────────────────────
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.darkPrimary),
        ),

        // ── Cards ─────────────────────────────────────────────────────────
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.darkBorder)),
          color: AppColors.darkSurfaceContainer,
        ),

        // ── Elevated Button ───────────────────────────────────────────────
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.darkPrimary,
            foregroundColor: AppColors.darkOnPrimary,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        // ── Outlined Button ───────────────────────────────────────────────
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkPrimary,
            side: const BorderSide(color: AppColors.darkPrimary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),

        // ── Text Button ───────────────────────────────────────────────────
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkPrimary,
          ),
        ),

        // ── Input Decoration ──────────────────────────────────────────────
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceLow,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBorder)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkBorder)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: AppColors.darkPrimary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkError)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.darkError, width: 2)),
          labelStyle: GoogleFonts.inter(color: AppColors.darkTextSubtle),
          hintStyle: GoogleFonts.inter(color: AppColors.darkOutline),
          prefixIconColor: AppColors.darkOutline,
        ),

        // ── Bottom Navigation ─────────────────────────────────────────────
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          selectedItemColor: AppColors.darkPrimary,
          unselectedItemColor: AppColors.darkOutline,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),

        // ── Divider ───────────────────────────────────────────────────────
        dividerTheme: const DividerThemeData(
            color: AppColors.darkBorderSubtle, thickness: 1, space: 1),

        // ── Scaffold ──────────────────────────────────────────────────────
        scaffoldBackgroundColor: AppColors.darkBackground,

        // ── Slider ────────────────────────────────────────────────────────
        sliderTheme: const SliderThemeData(
          activeTrackColor: AppColors.darkPrimary,
          inactiveTrackColor: AppColors.darkBorder,
          thumbColor: AppColors.darkPrimary,
          overlayColor: Color(0x1A7EB3FF),
        ),

        // ── Switch ────────────────────────────────────────────────────────
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.darkOnPrimary;
            }
            return AppColors.darkOutline;
          }),
          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.darkPrimary;
            }
            return AppColors.darkBorder;
          }),
        ),

        // ── ListTile ──────────────────────────────────────────────────────
        listTileTheme: const ListTileThemeData(
          iconColor: AppColors.darkOutline,
          textColor: AppColors.darkTextPrimary,
        ),

        // ── Icon ──────────────────────────────────────────────────────────
        iconTheme: const IconThemeData(
          color: AppColors.darkTextSubtle,
        ),
      );
}
