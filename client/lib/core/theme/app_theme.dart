import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme_colors.dart';

class AppTheme {
  AppTheme._();

  static TextTheme _textTheme(Color textColor, Color subtleColor) => TextTheme(
        displayLarge: GoogleFonts.plusJakartaSans(
            fontSize: 48, fontWeight: FontWeight.w700, letterSpacing: -0.96, color: textColor),
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
          secondary: AppColors.secondary,
          onSecondary: AppColors.white,
          tertiary: AppColors.tertiary,
          error: AppColors.error,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          surfaceContainerLowest: AppColors.white,
          surfaceContainerLow: AppColors.surfaceLow,
          surfaceContainer: AppColors.surfaceContainer,
          surfaceContainerHigh: AppColors.surfaceHigh,
          surfaceContainerHighest: AppColors.surfaceHighest,
          outline: AppColors.outline,
          outlineVariant: AppColors.outlineVariant,
          inverseSurface: AppColors.inverseSurface,
          onInverseSurface: AppColors.inverseOnSurface,
          inversePrimary: AppColors.inversePrimary,
        ),
        textTheme: _textTheme(AppColors.onSurface, AppColors.onSurfaceVariant),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: const BorderSide(color: AppColors.primary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surfaceLow,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.inversePrimary,
          onPrimary: Color(0xFF001453),
          secondary: Color(0xFFA4C9FF),
          onSecondary: Color(0xFF001C39),
          tertiary: Color(0xFF4EDEA3),
          error: Color(0xFFFFB4AB),
          surface: AppColors.inverseSurface,
          onSurface: AppColors.inverseOnSurface,
          outline: Color(0xFF8E8FA0),
          outlineVariant: Color(0xFF44454F),
          inversePrimary: AppColors.primary,
        ),
        textTheme: _textTheme(AppColors.inverseOnSurface, const Color(0xFFBCC0D0)),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.inverseSurface,
          foregroundColor: AppColors.inverseOnSurface,
          elevation: 0,
          scrolledUnderElevation: 1,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.inversePrimary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: const Color(0xFF44454F))),
          color: const Color(0xFF1E2638),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.inversePrimary,
            foregroundColor: const Color(0xFF001453),
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFF141B2B),
      );
}
