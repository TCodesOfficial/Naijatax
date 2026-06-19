import 'package:flutter/material.dart';

/// All colour tokens derived from the Stitch design files.
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color primary        = Color(0xFF00288E); // Deep Blue
  static const Color primaryFixed   = Color(0xFFDDE1FF);
  static const Color secondary      = Color(0xFF0060AC); // Medium Blue
  static const Color tertiary       = Color(0xFF003D27); // Deep Emerald

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color success        = Color(0xFF15803D); // Forest Green
  static const Color error          = Color(0xFFBA1A1A);
  static const Color govRed         = Color(0xFFB91C1C); // Tax liability red

  // ── Surface (Light Mode) ───────────────────────────────────────────────────
  static const Color background     = Color(0xFFF9F9FF);
  static const Color surface        = Color(0xFFF9F9FF);
  static const Color surfaceLow     = Color(0xFFF1F3FF);
  static const Color surfaceContainer  = Color(0xFFE9EDFF);
  static const Color surfaceHigh    = Color(0xFFE1E8FD);
  static const Color surfaceHighest = Color(0xFFDCE2F7);
  static const Color surfaceGray    = Color(0xFFF9FAFB);
  static const Color white          = Color(0xFFFFFFFF);

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color onSurface      = Color(0xFF141B2B); // Primary text
  static const Color onSurfaceVariant = Color(0xFF444653); // Secondary text
  static const Color outline        = Color(0xFF757684);
  static const Color outlineVariant = Color(0xFFC4C5D5);

  // ── Dark Mode Surface ──────────────────────────────────────────────────────
  static const Color inverseSurface  = Color(0xFF293040);
  static const Color inverseOnSurface = Color(0xFFEDF0FF);
  static const Color inversePrimary  = Color(0xFFB8C4FF);
}
