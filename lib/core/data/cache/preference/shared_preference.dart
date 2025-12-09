import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class SharedPreference {
  static const storage = FlutterSecureStorage();
  static final logger = Logger();
  static const errorSharedPref = 'Error From SharedPreference => ';

  static Future<String?> getValue(String key) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      logger.e('$errorSharedPref $e');
      return null;
    }
  }

  static Future<bool> setValue(String key, String value) async {
    bool saved = false;
    try {
      await storage.write(key: key, value: value);
      saved = true;
    } catch (e) {
      logger.e('$errorSharedPref $e');
    }
    return saved;
  }

  static Future<void> remove(String key) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      logger.e('$errorSharedPref $e');
    }
  }

  static Future<void> removeMultiple(RegExp pattern) async {
    try {
      final all = await storage.readAll();
      for (var key in all.keys) {
        if (pattern.hasMatch(key)) {
          await storage.delete(key: key);
        }
      }
    } catch (e) {
      logger.e('$errorSharedPref $e');
    }
  }

  static Future<bool> setBool(String key, bool value) async {
    bool saved = false;
    try {
      await storage.write(key: key, value: value.toString());
      saved = true;
    } catch (e) {
      logger.e('$errorSharedPref $e');
    }
    return saved;
  }

  static Future<bool> getBool(String key) async {
    try {
      final value = await getValue(key);
      return value?.toLowerCase() == 'true';
    } catch (e) {
      logger.e('$errorSharedPref $e');
      return false;
    }
  }

  static Future<void> removeAll() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      logger.e('$errorSharedPref $e');
    }
  }
}
