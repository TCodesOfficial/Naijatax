import 'package:flutter/material.dart';

class AnimatedButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String text;
  final Widget? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isOutlined;

  const AnimatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.foregroundColor,
    this.isOutlined = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1.0 - _controller.value;
    final theme = Theme.of(context);
    final isEnabled = widget.onPressed != null && !widget.isLoading;

    final defaultBgColor = widget.backgroundColor ?? theme.colorScheme.primary;
    final defaultFgColor = widget.foregroundColor ??
        (widget.isOutlined ? theme.colorScheme.primary : theme.colorScheme.onPrimary);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () {
        if (isEnabled) _controller.reverse();
      },
      onTap: isEnabled ? widget.onPressed : null,
      child: Transform.scale(
        scale: _scale,
        child: SizedBox(
          height: 48,
          child: widget.isOutlined
              ? OutlinedButton(
                  onPressed: isEnabled ? widget.onPressed : null,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: defaultFgColor,
                    side: BorderSide(color: defaultBgColor, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _buildChild(defaultFgColor),
                )
              : ElevatedButton(
                  onPressed: isEnabled ? widget.onPressed : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultBgColor,
                    foregroundColor: defaultFgColor,
                    disabledBackgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                    disabledForegroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: _buildChild(defaultFgColor),
                ),
        ),
      ),
    );
  }

  Widget _buildChild(Color fgColor) {
    if (widget.isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(fgColor),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.icon != null) ...[
          widget.icon!,
          const SizedBox(width: 8),
        ],
        Flexible(
          child: Text(
            widget.text,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
