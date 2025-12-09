import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'string_enum.dart';

class AppTranslations extends Translations {
  static const supportedLocales = [
    Locale("en"),
    Locale("bn"),
  ];

  @override
  Map<String, Map<String, String>> get keys => {
        'en': _generateTranslations((e) => e.en),
        'bn': _generateTranslations((e) => e.bn),
      };

  static Map<String, String> _generateTranslations(String Function(TextEnum) translationMapper) {
    return Map.fromEntries(
      TextEnum.values.map(
        (e) => MapEntry(e.name, translationMapper(e)),
      ),
    );
  }
}
