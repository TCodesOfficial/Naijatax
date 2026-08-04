import 'package:flutter/material.dart';

/// All colour tokens derived from the NaijaTax design system.
/// Brand accent: Deep Blue (#00288E) → consistent blue-tinted palette in both modes.
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF00288E); // Deep Navy Blue
  static const Color primaryFixed   = Color(0xFFDDE1FF);
  static const Color secondary      = Color(0xFF0060AC); // Medium Blue
  static const Color tertiary       = Color(0xFF003D27); // Deep Emerald

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF15803D); // Forest Green (light)
  static const Color error          = Color(0xFFBA1A1A);
  static const Color govRed         = Color(0xFFB91C1C); // Tax liability red (light)

  // ── Surface (Light Mode) ───────────────────────────────────────────────────
  static const Color background     = Color(0xFFF9F9FF);
  static const Color surface        = Color(0xFFF9F9FF);
  static const Color surfaceLow     = Color(0xFFF1F3FF);
  static const Color surfaceContainer  = Color(0xFFE9EDFF);
  static const Color surfaceHigh    = Color(0xFFE1E8FD);
  static const Color surfaceHighest = Color(0xFFDCE2F7);
  static const Color surfaceGray    = Color(0xFFF9FAFB);
  static const Color white          = Color(0xFFFFFFFF);

  // ── Text (Light Mode) ──────────────────────────────────────────────────────
  static const Color onSurface      = Color(0xFF141B2B); // Primary text
  static const Color onSurfaceVariant = Color(0xFF444653); // Secondary text
  static const Color outline        = Color(0xFF757684);
  static const Color outlineVariant = Color(0xFFC4C5D5);

  // ── Dark Mode: Base Surfaces ───────────────────────────────────────────────
  // All surfaces use HSL ~222° (pure blue) to give a rich, cohesive navy feel.
  static const Color darkBackground       = Color(0xFF0C1120); // Deepest bg – near-black navy
  static const Color darkSurface          = Color(0xFF111827); // Main surface – deep blue-navy
  static const Color darkSurfaceLow       = Color(0xFF162033); // Input / list bg
  static const Color darkSurfaceContainer = Color(0xFF1A2640); // Card / container
  static const Color darkSurfaceHigh      = Color(0xFF1E2D4A); // Elevated card
  static const Color darkSurfaceHighest   = Color(0xFF243355); // Highest elevation

  // ── Dark Mode: Borders & Outlines ─────────────────────────────────────────
  static const Color darkBorder           = Color(0xFF2A3A5C); // Standard border
  static const Color darkBorderSubtle     = Color(0xFF1F2E47); // Subtle divider
  static const Color darkOutline          = Color(0xFF6B82B0); // Muted blue-grey outline text
  static const Color darkOutlineVariant   = Color(0xFF253045); // Low-contrast outline variant

  // ── Dark Mode: Text ───────────────────────────────────────────────────────
  static const Color darkTextPrimary      = Color(0xFFE8EEFF); // Crisp white-blue primary text
  static const Color darkTextSubtle       = Color(0xFF8FA3CC); // Muted blue-tinted secondary text

  // ── Dark Mode: Brand Accents ──────────────────────────────────────────────
  // Primary accent in dark — a bright but not blinding sky blue
  static const Color darkPrimary          = Color(0xFF7EB3FF); // Bright blue accent
  static const Color darkOnPrimary        = Color(0xFF001A4D); // Dark text on blue
  static const Color darkPrimaryContainer = Color(0xFF002A6B); // Tonal container
  static const Color darkOnPrimaryContainer = Color(0xFFD5E4FF); // Text on container

  // Secondary — a lighter, teal-shifted blue for contrast
  static const Color darkSecondary          = Color(0xFF93C5FD); // Sky-blue secondary
  static const Color darkOnSecondary        = Color(0xFF00204A); // Dark text on secondary
  static const Color darkSecondaryContainer = Color(0xFF003570); // Secondary tonal container
  static const Color darkOnSecondaryContainer = Color(0xFFCEE3FF); // Text on container

  // Tertiary — a warm cyan/teal to provide a complementary accent
  static const Color darkTertiary          = Color(0xFF5ECDE8); // Cyan accent
  static const Color darkOnTertiary        = Color(0xFF003541); // Text on tertiary
  static const Color darkTertiaryContainer = Color(0xFF00505F); // Tonal tertiary container
  static const Color darkOnTertiaryContainer = Color(0xFFB3EEFF); // Text on tertiary container

  // ── Dark Mode: Semantic ───────────────────────────────────────────────────
  static const Color darkError            = Color(0xFFFF8A80); // Bright rose-red (readable on dark)
  static const Color darkOnError          = Color(0xFF5D0000);
  static const Color darkErrorContainer   = Color(0xFF7A1C1C); // Dark error container
  static const Color darkOnErrorContainer = Color(0xFFFFDAD6); // Text on error container

  // Success — bright mint green (readable on dark backgrounds)
  static const Color darkSuccess          = Color(0xFF4ADE80); // Bright emerald
  static const Color darkGovRed           = Color(0xFFF87171); // Tax red (bright for dark)

  // ── Inverse (for snackbars, tooltips, etc.) ──────────────────────────────
  static const Color inverseSurface       = Color(0xFFE4E6F0); // Light for dark inverse
  static const Color inverseOnSurface     = Color(0xFF2A3350);
  static const Color inversePrimary       = Color(0xFF7EB3FF); // Matches darkPrimary
}
