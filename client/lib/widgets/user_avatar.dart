import 'package:cached_network_image_ce/cached_network_image.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarUrl;
  final String? displayName;
  final double radius;
  final IconData fallbackIcon;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;

  const UserAvatar({
    super.key,
    this.avatarUrl,
    this.displayName,
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

  String get _initials {
    if (displayName == null || displayName!.trim().isEmpty) return '';
    final parts = displayName!.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts.last[0]}'.toUpperCase();
  }

  Color get _avatarColor {
    if (backgroundColor != null) return backgroundColor!;
    final name = displayName ?? '';
    final hash = name.isEmpty ? 0 : name.hashCode;
    const palette = [
      Color(0xFF1E88E5),
      Color(0xFF43A047),
      Color(0xFFE53935),
      Color(0xFF8E24AA),
      Color(0xFFFF8F00),
      Color(0xFF00897B),
      Color(0xFF5C6BC0),
      Color(0xFFD81B60),
    ];
    return palette[hash.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.primaryContainer;
    final ic = iconColor ?? theme.colorScheme.primary;
    final icSize = iconSize ?? radius * 1.25;

    return CircleAvatar(
      radius: radius,
      backgroundColor: hasValidUrl ? bg : _avatarColor,
      child: hasValidUrl
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: avatarUrl!,
                width: radius * 2,
                height: radius * 2,
                fit: BoxFit.cover,
                placeholder: (context, url) => _buildFallback(ic, icSize),
                errorBuilder: (context, url, error) => _buildFallback(ic, icSize),
              ),
            )
          : _initials.isNotEmpty
              ? Text(
                  _initials,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: radius * 0.8,
                    fontWeight: FontWeight.w700,
                  ),
                )
              : _buildFallback(ic, icSize),
    );
  }

  Widget _buildFallback(Color ic, double icSize) {
    return Icon(fallbackIcon, size: icSize, color: ic);
  }
}
