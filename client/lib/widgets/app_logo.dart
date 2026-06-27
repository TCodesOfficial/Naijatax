import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double radius;
  final double? iconSize;

  const AppLogo({
    super.key,
    this.radius = 18,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CircleAvatar(
      radius: radius,
      backgroundColor: theme.colorScheme.primary,
      child: Icon(
        Icons.account_balance,
        color: theme.colorScheme.onPrimary,
        size: iconSize ?? radius + 2,
      ),
    );
  }
}
