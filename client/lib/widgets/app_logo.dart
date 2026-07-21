import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
      return SvgPicture.asset(
        AppConstants.logoLongAsset,
        height: size,
        placeholderBuilder: (_) => Icon(
          Icons.account_balance,
          size: size,
          color: theme.colorScheme.primary,
        ),
      );
    }

    return SvgPicture.asset(
      AppConstants.logoSquareAsset,
      width: size,
      height: size,
      placeholderBuilder: (_) => Icon(
        Icons.account_balance,
        size: size,
        color: theme.colorScheme.primary,
      ),
    );
  }
}
