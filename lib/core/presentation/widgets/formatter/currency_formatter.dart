import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final String locale;
  late final NumberFormat _formatter;

  CurrencyInputFormatter({this.locale = 'en_BD'}) {
    _formatter = NumberFormat.decimalPattern(locale);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Parse and format
    final number = int.tryParse(newText);
    if (number == null) {
      return oldValue;
    }

    final formatted = _formatter.format(number);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DecimalCurrencyInputFormatter extends TextInputFormatter {
  final String locale;
  final int decimalDigits;
  late final NumberFormat _formatter;

  DecimalCurrencyInputFormatter({
    this.locale = 'en_BD',
    this.decimalDigits = 2,
  }) {
    _formatter = NumberFormat.decimalPattern(locale);
  }

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove all non-digit and non-decimal characters
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9.]'), '');

    // Allow only one decimal point
    final parts = newText.split('.');
    if (parts.length > 2) {
      return oldValue;
    }

    if (newText.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // If there's a decimal point, limit decimal places
    if (parts.length == 2 && parts[1].length > decimalDigits) {
      return oldValue;
    }

    // Format the integer part
    if (parts[0].isNotEmpty) {
      final intPart = int.tryParse(parts[0]);
      if (intPart != null) {
        String formatted = _formatter.format(intPart);
        if (parts.length == 2) {
          formatted += '.${parts[1]}';
        } else if (newText.endsWith('.')) {
          formatted += '.';
        }

        return TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    }

    return newValue;
  }
}

// Helper class for formatting display
class CurrencyFormatter {
  static String format(double amount, String locale, String currencySymbol) {
    final formatter = NumberFormat.decimalPattern(locale);
    return '$currencySymbol ${formatter.format(amount)}';
  }

  static String formatCompact(double amount, String locale, String currencySymbol) {
    final formatter = NumberFormat.compact(locale: locale);
    return '$currencySymbol ${formatter.format(amount)}';
  }
}

