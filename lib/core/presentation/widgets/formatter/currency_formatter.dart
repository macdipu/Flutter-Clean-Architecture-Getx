import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

enum NumberFormatStyle {
  indian, // #,##,###
  international, // #,###,###
  european, // # ### ###
  german // #.###.###
}

abstract class AbstractCurrencyFormatter {
  String formatAmount(double amount, NumberFormatStyle formatStyle);
  String formatCurrency(double amount, NumberFormatStyle formatStyle, String currencySymbol, {bool showSymbol = true});
  double parseAmount(String formattedAmount, NumberFormatStyle formatStyle, String currencySymbol);
}

class CustomCurrencyFormatter extends AbstractCurrencyFormatter {
  @override
  String formatAmount(double amount, NumberFormatStyle formatStyle) {
    final amountStr = amount.toStringAsFixed(2);
    final parts = amountStr.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '00';

    String formattedInteger = '';
    final reversed = integerPart.split('').reversed.toList();

    switch (formatStyle) {
      case NumberFormatStyle.indian:
        for (int i = 0; i < reversed.length; i++) {
          if (i == 3 || (i > 3 && (i - 3) % 2 == 0)) {
            formattedInteger = ',$formattedInteger';
          }
          formattedInteger = reversed[i] + formattedInteger;
        }
        break;
      case NumberFormatStyle.international:
        for (int i = 0; i < reversed.length; i++) {
          if (i > 0 && i % 3 == 0) {
            formattedInteger = ',$formattedInteger';
          }
          formattedInteger = reversed[i] + formattedInteger;
        }
        break;
      case NumberFormatStyle.european:
        for (int i = 0; i < reversed.length; i++) {
          if (i > 0 && i % 3 == 0) {
            formattedInteger = ' $formattedInteger';
          }
          formattedInteger = reversed[i] + formattedInteger;
        }
        break;
      case NumberFormatStyle.german:
        for (int i = 0; i < reversed.length; i++) {
          if (i > 0 && i % 3 == 0) {
            formattedInteger = '.$formattedInteger';
          }
          formattedInteger = reversed[i] + formattedInteger;
        }
        break;
    }

    return '$formattedInteger.$decimalPart';
  }

  @override
  String formatCurrency(double amount, NumberFormatStyle formatStyle, String currencySymbol, {bool showSymbol = true}) {
    final formatted = formatAmount(amount, formatStyle);
    return showSymbol ? '$currencySymbol $formatted' : formatted;
  }

  @override
  double parseAmount(String formattedAmount, NumberFormatStyle formatStyle, String currencySymbol) {
    // Remove currency symbol and spaces
    String cleaned = formattedAmount
        .replaceAll(currencySymbol, '')
        .replaceAll(' ', '')
        .replaceAll(',', '')
        .trim();

    // Handle German format (dot as thousand separator)
    if (formatStyle == NumberFormatStyle.german) {
      // Keep only the last dot as decimal separator
      final parts = cleaned.split('.');
      if (parts.length > 1) {
        cleaned = '${parts.sublist(0, parts.length - 1).join('')}.${parts.last}';
      }
    }

    return double.tryParse(cleaned) ?? 0.0;
  }
}

class IntlCurrencyFormatter extends AbstractCurrencyFormatter {
  @override
  String formatAmount(double amount, NumberFormatStyle formatStyle) {
    String pattern;
    switch (formatStyle) {
      case NumberFormatStyle.indian:
        pattern = "##,##,###.##";
        break;
      case NumberFormatStyle.international:
        pattern = "#,###,###.##";
        break;
      case NumberFormatStyle.european:
        pattern = "# ### ###.##";
        break;
      case NumberFormatStyle.german:
        pattern = "#.###.###,##";
        break;
    }
    return NumberFormat(pattern).format(amount);
  }

  @override
  String formatCurrency(double amount, NumberFormatStyle formatStyle, String currencySymbol, {bool showSymbol = true}) {
    final formatter = NumberFormat.currency(symbol: showSymbol ? currencySymbol : "");
    return formatter.format(amount);
  }

  @override
  double parseAmount(String formattedAmount, NumberFormatStyle formatStyle, String currencySymbol) {
    final cleaned = formattedAmount.replaceAll(currencySymbol, "").trim();
    return NumberFormat().parse(cleaned).toDouble();
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormatStyle formatStyle;

  CurrencyInputFormatter(this.formatStyle);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    // Clean the input
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Split into integer and decimal
    final parts = cleanText.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    // Format the integer part based on the provided format style
    String formattedInteger = CustomCurrencyFormatter().formatAmount(double.parse(integerPart), formatStyle);

    // Combine
    String formatted = formattedInteger;
    if (decimalPart.isNotEmpty) {
      formatted += '.$decimalPart';
    }

    return newValue.copyWith(text: formatted, selection: TextSelection.collapsed(offset: formatted.length));
  }
}
