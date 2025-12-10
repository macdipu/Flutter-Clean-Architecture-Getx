import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A customizable text form field widgets with consistent styling
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final TextStyle? prefixStyle;
  final String? helperText;
  final bool enabled;
  final bool readOnly;
  final int maxLines;
  final int? minLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextStyle? style;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label = '',
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.prefixStyle,
    this.helperText,
    this.enabled = true,
    this.readOnly = false,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    this.onChanged,
    this.onTap,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.maxLength,
    this.textInputAction,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      enabled: enabled,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      obscureText: obscureText,
      maxLength: maxLength,
      textInputAction: textInputAction,
      style: style,
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        prefixText: prefixText,
        prefixStyle: prefixStyle,
        helperText: helperText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: enabled && !readOnly
            ? Theme.of(context).inputDecorationTheme.fillColor
            : Colors.grey.shade200,
      ),
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
    );
  }
}

