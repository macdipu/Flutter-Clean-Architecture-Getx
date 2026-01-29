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
  final AbstractCurrencyFormatter formatter;

  CurrencyInputFormatter(
      this.formatStyle, {
        AbstractCurrencyFormatter? formatter,
      }) : formatter = formatter ?? CustomCurrencyFormatter();

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;

    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    if (cleanText.split('.').length > 2) {
      return oldValue;
    }

    final parts = cleanText.split('.');
    final integerPart = parts[0];
    final decimalPart = parts.length > 1 ? parts[1] : '';

    if (integerPart.isEmpty) {
      return newValue.copyWith(
        text: cleanText,
        selection: TextSelection.collapsed(offset: cleanText.length),
      );
    }

    final amount = double.tryParse(integerPart) ?? 0.0;
    String formattedInteger = formatter.formatAmount(amount, formatStyle);

    if (formattedInteger.contains('.')) {
      formattedInteger = formattedInteger.split('.')[0];
    }

    String formatted = formattedInteger;
    if (decimalPart.isNotEmpty || cleanText.endsWith('.')) {
      formatted += '.';
      if (decimalPart.isNotEmpty) {
        formatted += decimalPart.length > 2 ? decimalPart.substring(0, 2) : decimalPart;
      }
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
