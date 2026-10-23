import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/app_snack.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/animated_button.dart';
import '../../widgets/custom_text_field.dart';

class OtpPane extends ConsumerStatefulWidget {
  const OtpPane({
    super.key,
    required this.controller,
    required this.pendingPhone,
    required this.isLoading,
    required this.verifyButtonText,
    required this.onChangeNumber,
    this.compact = false,
  });

  final TextEditingController controller;
  final String? pendingPhone;
  final bool isLoading;
  final String verifyButtonText;
  final VoidCallback onChangeNumber;
  final bool compact;

  @override
  ConsumerState<OtpPane> createState() => _OtpPaneState();
}

class _OtpPaneState extends ConsumerState<OtpPane> {
  void _verifyOtp() async {
    if (widget.controller.text.trim().length != 6) {
      showAppSnack(context, 'Please enter a valid 6-digit OTP');
      return;
    }
    final pending = widget.pendingPhone;
    if (pending == null) {
      widget.onChangeNumber();
      if (mounted) {
        showAppSnack(context, 'Request a new code and try again.');
      }
      return;
    }

    await ref
        .read(authProvider.notifier)
        .verifyOtp(pending, widget.controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final compact = widget.compact;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Enter the 6-digit code sent to ${widget.pendingPhone}',
          textAlign: TextAlign.center,
          style: (compact
                  ? theme.textTheme.bodySmall
                  : theme.textTheme.bodyMedium)
              ?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: compact ? 8 : 10),
        CustomTextField(
          controller: widget.controller,
          label: 'OTP Code',
          hintText: '000000',
          keyboardType: TextInputType.number,
          maxLength: 6,
          prefixIcon: Icon(
            Icons.pin_outlined,
            size: compact ? 18 : 20,
          ),
        ),
        SizedBox(height: compact ? 12 : 14),
        AnimatedButton(
          onPressed: _verifyOtp,
          text: widget.verifyButtonText,
          isLoading: widget.isLoading,
          icon: const Icon(Icons.check_circle, size: 18),
        ),
        SizedBox(height: compact ? 6 : 8),
        TextButton(
          onPressed: widget.onChangeNumber,
          child: Text(
            'Change phone number',
            style: compact ? const TextStyle(fontSize: 12) : null,
          ),
        ),
      ],
    );
  }
}
