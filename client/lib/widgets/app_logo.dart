import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';

enum LogoVariant { square, long }

class AppLogo extends StatelessWidget {
  final double radius;
  final double? iconSize;
  final LogoVariant variant;

  const AppLogo({
    super.key,
    this.radius = 18,
    this.iconSize,
    this.variant = LogoVariant.square,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = iconSize ?? radius + 2;

    if (variant == LogoVariant.long) {
      return Image.asset(
        AppConstants.logoLongAsset,
        height: size,
        cacheWidth: (size * 2).toInt(),
        cacheHeight: (size * 2).toInt(),
        errorBuilder: (_, __, ___) => Icon(
          Icons.account_balance,
          size: size,
          color: theme.colorScheme.primary,
        ),
      );
    }

    return Image.asset(
      AppConstants.logoSquareAsset,
      width: size,
      height: size,
      cacheWidth: (size * 2).toInt(),
      cacheHeight: (size * 2).toInt(),
      errorBuilder: (_, __, ___) => Icon(
        Icons.account_balance,
        size: size,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
