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
  // Blue-purple tinted dark theme with layered contrasts
  static const _darkBluePurple = Color(0xFF121624);
  static const _darkSurface = Color(0xFF1C2236);
  static const _darkCard = Color(0xFF1E2540);
  static const _darkInput = Color(0xFF1A2034);
  static const _darkContainer = Color(0xFF222840);
  static const _darkContainerHigh = Color(0xFF2A3050);
  static const _darkContainerHighest = Color(0xFF343C58);
  static const _darkBorder = Color(0xFF2E3550);
  static const _darkBorderSubtle = Color(0xFF3A4060);
  static const _darkOutline = Color(0xFF7A80A8);
  static const _darkOutlineVariant = Color(0xFF3A4060);
  static const _darkTextPrimary = Color(0xFFE2E6F0);
  static const _darkTextSubtle = Color(0xFFA0A8C0);

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
          surface: _darkSurface,
          onSurface: _darkTextPrimary,
          surfaceContainerLowest: _darkBluePurple,
          surfaceContainerLow: _darkInput,
          surfaceContainer: _darkContainer,
          surfaceContainerHigh: _darkContainerHigh,
          surfaceContainerHighest: _darkContainerHighest,
          outline: _darkOutline,
          outlineVariant: _darkOutlineVariant,
          inversePrimary: AppColors.primary,
        ),
        textTheme: _textTheme(_darkTextPrimary, _darkTextSubtle),
        appBarTheme: AppBarTheme(
          backgroundColor: _darkSurface,
          foregroundColor: _darkTextPrimary,
          elevation: 0,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          titleTextStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.inversePrimary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: _darkBorder)),
          color: _darkCard,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.inversePrimary,
            foregroundColor: const Color(0xFF001453),
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
            foregroundColor: AppColors.inversePrimary,
            side: const BorderSide(color: AppColors.inversePrimary),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle:
                GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: _darkInput,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _darkBorder)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: _darkBorder)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.inversePrimary, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFFB4AB))),
          labelStyle: GoogleFonts.inter(color: _darkTextSubtle),
          hintStyle: GoogleFonts.inter(color: _darkOutline),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _darkSurface,
          selectedItemColor: AppColors.inversePrimary,
          unselectedItemColor: _darkOutline,
          elevation: 8,
          type: BottomNavigationBarType.fixed,
        ),
        dividerTheme: const DividerThemeData(
            color: _darkBorderSubtle, thickness: 1, space: 1),
        scaffoldBackgroundColor: _darkBluePurple,
      );
}
