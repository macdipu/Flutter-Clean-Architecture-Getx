import 'package:com.onkur.customer/core/domain/usecase/usecase.dart';
import 'package:com.onkur.customer/core/presentation/utils/logger.dart';
import 'package:com.onkur.customer/core/presentation/utils/task_runner.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A wrapper around [SharedPreferences] for simple key-value persistence.
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  late final SharedPreferences _prefs;

  /// Initialize SharedPreferences instance.
  ResultFuture<void> init() async {
    return runTask(() async {
      _prefs = await SharedPreferences.getInstance();
      AppLogger.info('StorageService (SharedPreferences) initialized');
    });
  }

  // --- SETTERS ---

  ResultFuture<bool> setString(String key, String value) async =>
      runTask(() => _prefs.setString(key, value));

  ResultFuture<bool> setBool(String key, bool value) async =>
      runTask(() => _prefs.setBool(key, value));

  ResultFuture<bool> setInt(String key, int value) async =>
      runTask(() => _prefs.setInt(key, value));

  ResultFuture<bool> setDouble(String key, double value) async =>
      runTask(() => _prefs.setDouble(key, value));

  ResultFuture<bool> setStringList(String key, List<String> value) async =>
      runTask(() => _prefs.setStringList(key, value));

  // --- GETTERS ---

  String? getString(String key) => _prefs.getString(key);
  bool? getBool(String key) => _prefs.getBool(key);
  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  // --- COMMON ---

  bool containsKey(String key) => _prefs.containsKey(key);

  ResultFuture<bool> remove(String key) async =>
      runTask(() => _prefs.remove(key));

  ResultFuture<bool> clear() async =>
      runTask(() => _prefs.clear());
}
