abstract class BasePreference {
  Future<String?> getValue(String key);

  Future<bool> setValue(String key, String value);

  Future<void> remove(String key);

  Future<void> removeMultiple(RegExp pattern);

  Future<void> removeAll();
}
