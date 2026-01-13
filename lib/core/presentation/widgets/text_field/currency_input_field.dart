import 'package:flutter_clean_architecture_getx/core/presentation/widgets/formatter/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'custom_text_field.dart';

class CurrencyInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool enabled;
  final FormFieldValidator<String>? validator;
  final void Function(String)? onChanged;

  const CurrencyInputField({
    super.key,
    required this.controller,
    this.label = 'Amount',
    this.hint,
    this.enabled = true,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomTextField(
        controller: controller,
        label: label,
        hint: hint ?? 'Enter amount',
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        inputFormatters: [
          CurrencyInputFormatter(
              NumberFormatStyle.indian
          ),
        ],
        prefixText: '\$',
        prefixStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Theme.of(context).primaryColor,
        ),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              final amount = getRawAmount(value);
              if (amount <= 0) {
                return 'Please enter a valid amount';
              }
              return null;
            },
        onChanged: onChanged,
      ),
    );
  }

  // Helper method to get the raw number from formatted text
  static double getRawAmount(String formattedText) {
    final cleanText = formattedText
        .replaceAll(RegExp(r'[^\d.]'), '')
        .trim();
    return double.tryParse(cleanText) ?? 0.0;
  }
}
