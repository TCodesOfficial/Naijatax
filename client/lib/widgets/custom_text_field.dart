import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;

    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return const TextEditingValue();

    final formatted = _addCommas(digitsOnly);

    final selectionIndex = newValue.selection.end +
        (formatted.length - newValue.text.length);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(
        offset: selectionIndex.clamp(0, formatted.length),
      ),
    );
  }

  String _addCommas(String digits) {
    final buffer = StringBuffer();
    final length = digits.length;

    for (int i = 0; i < length; i++) {
      final digit = digits[length - 1 - i];
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(digit);
    }

    return buffer.toString().split('').reversed.join();
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final ValueChanged<String>? onChanged;
  final int? maxLength;
  final bool useThousandsSeparator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.onChanged,
    this.maxLength,
    this.useThousandsSeparator = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLength: maxLength,
          inputFormatters: useThousandsSeparator
              ? [ThousandsSeparatorInputFormatter()]
              : null,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            isDense: true,
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            counterText: '',
          ),
        ),
      ],
    );
  }
}
