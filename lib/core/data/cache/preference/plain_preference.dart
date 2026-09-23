import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'base_preference.dart';

class PlainPreference implements BasePreference {
  const PlainPreference();

  static final _prefs = SharedPreferencesAsync();
  static final _logger = Logger();
  static const _errorPrefix = 'Error From PlainPreference => ';

  @override
  Future<String?> getValue(String key) async {
    try {
      return await _prefs.getString(key);
    } catch (e) {
      _logger.e('$_errorPrefix $e');
      return null;
    }
  }

  @override
  Future<bool> setValue(String key, String value) async {
    try {
      await _prefs.setString(key, value);
      return true;
    } catch (e) {
      _logger.e('$_errorPrefix $e');
      return false;
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      _logger.e('$_errorPrefix $e');
    }
  }

  @override
  Future<void> removeMultiple(RegExp pattern) async {
    try {
      final keys = await _prefs.getKeys();
      for (final key in keys) {
        if (pattern.hasMatch(key)) {
          await _prefs.remove(key);
        }
      }
    } catch (e) {
      _logger.e('$_errorPrefix $e');
    }
  }

  @override
  Future<void> removeAll() async {
    try {
      await _prefs.clear();
    } catch (e) {
      _logger.e('$_errorPrefix $e');
    }
  }
}
