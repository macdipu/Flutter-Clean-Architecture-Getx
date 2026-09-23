import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import 'base_preference.dart';

class SecurePreference implements BasePreference {
  const SecurePreference();

  static const _storage = FlutterSecureStorage();
  static final _logger = Logger();
  static const _errorPrefix = 'Error From SecurePreference => ';

  @override
  Future<String?> getValue(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      _logger.e('$_errorPrefix $e');
      return null;
    }
  }

  @override
  Future<bool> setValue(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
      return true;
    } catch (e) {
      _logger.e('$_errorPrefix $e');
      return false;
    }
  }

  @override
  Future<void> remove(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      _logger.e('$_errorPrefix $e');
    }
  }

  @override
  Future<void> removeMultiple(RegExp pattern) async {
    try {
      final all = await _storage.readAll();
      for (final key in all.keys) {
        if (pattern.hasMatch(key)) {
          await _storage.delete(key: key);
        }
      }
    } catch (e) {
      _logger.e('$_errorPrefix $e');
    }
  }

  @override
  Future<void> removeAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      _logger.e('$_errorPrefix $e');
    }
  }
}
