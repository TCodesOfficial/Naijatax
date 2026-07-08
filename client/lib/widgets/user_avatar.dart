import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double radius;
  final IconData fallbackIcon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    required this.radius,
    this.fallbackIcon = Icons.person,
    this.iconSize,
    this.backgroundColor,
    this.iconColor,
  });

  bool get hasValidUrl =>
      avatarUrl != null &&
      avatarUrl!.trim().isNotEmpty &&
      (avatarUrl!.startsWith('http://') || avatarUrl!.startsWith('https://'));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primaryContainer;
    final ic = iconColor ?? theme.colorScheme.primary;
    final icSize = iconSize ?? radius * 1.25;

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: hasValidUrl
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (context, url) => Icon(
                  fallbackIcon,
                  size: icSize,
                  color: ic,
                ),
                errorBuilder: (context, url, error) => Icon(
                  fallbackIcon,
                  size: icSize,
                  color: ic,
                ),
              ),
            )
          : Icon(
              fallbackIcon,
              size: icSize,
              color: ic,
            ),
    );
  }
}
