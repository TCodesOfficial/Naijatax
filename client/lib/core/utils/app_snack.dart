import 'package:flutter/material.dart';

/// Canonical snackbar: [success] → green, [error] → theme error color,
/// otherwise the theme default (inverse surfaces).
void showAppSnack(
  BuildContext context,
  String message, {
  bool success = false,
  bool error = false,
  SnackBarBehavior? behavior,
  Duration? duration,
  EdgeInsetsGeometry? margin,
  SnackBarAction? action,
}) {
  final color = success
      ? Colors.green
      : error
          ? Theme.of(context).colorScheme.error
          : null;
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: color,
      behavior: behavior,
      // SnackBar.duration is non-nullable, so fall back to its default.
      duration: duration ?? const Duration(milliseconds: 4000),
      margin: margin,
      action: action,
    ),
  );
}
