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

    final int cursorPosition = newValue.selection.baseOffset;

    // Clean the text - remove all non-digit and non-decimal characters
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');

    // Prevent multiple decimal points
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

    int digitsBeforeCursor = 0;
    bool cursorIsAfterDecimal = false;
    int decimalCursorOffset = 0;

    for (int i = 0; i < cursorPosition && i < newValue.text.length; i++) {
      final char = newValue.text[i];
      if (RegExp(r'\d').hasMatch(char)) {
        if (!cursorIsAfterDecimal) {
          digitsBeforeCursor++;
        }
      } else if (char == '.' && !cursorIsAfterDecimal) {
        cursorIsAfterDecimal = true;
        for (int j = i + 1; j < cursorPosition && j < newValue.text.length; j++) {
          decimalCursorOffset++;
        }
        break;
      }
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

    int newCursorPosition = 0;

    if (cursorIsAfterDecimal && formatted.contains('.')) {
      final decimalIndex = formatted.indexOf('.');
      newCursorPosition = decimalIndex + 1 + decimalCursorOffset;
    } else {
      int digitCount = 0;
      for (int i = 0; i < formatted.length; i++) {
        if (RegExp(r'\d').hasMatch(formatted[i])) {
          digitCount++;
          if (digitCount == digitsBeforeCursor) {
            newCursorPosition = i + 1;
            break;
          }
        }
      }

      if (newCursorPosition == 0) {
        if (digitsBeforeCursor == 0) {
          newCursorPosition = 0;
        } else {
          if (formatted.contains('.')) {
            newCursorPosition = formatted.indexOf('.');
          } else {
            newCursorPosition = formatted.length;
          }
        }
      }
    }

    newCursorPosition = newCursorPosition.clamp(0, formatted.length);

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }
}
