import 'package:flutter/material.dart';

/// Small rounded pill shown inside text fields as a live hint
/// (e.g. "₦1.8M/yr · 15%", "20% relief · ₦100k", "CIT: EXEMPT").
class TaxHintPill extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color? color;

  const TaxHintPill({
    super.key,
    required this.text,
    this.icon = Icons.percent_rounded,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = color ?? theme.colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: base.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: base.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: base),
          const SizedBox(width: 4),
          Text(
            text,
            style: theme.textTheme.labelSmall?.copyWith(
              color: base,
              fontWeight: FontWeight.w700,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
