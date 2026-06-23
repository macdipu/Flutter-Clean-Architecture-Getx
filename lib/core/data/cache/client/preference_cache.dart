import '../preference/shared_preference.dart';
import 'base_cache.dart';

class PreferenceCache extends BaseCache {
  static const String _lastCachedAtKey = 'cache_control:last_cached_at';

  @override
  Future<String?> get(String key) async {
    final data = await SharedPreference.getValue('$key:data');
    if (data == null) return null;

    final expiresAt = await SharedPreference.getValue('$key:expires_at');
    if (expiresAt != null && int.parse(expiresAt) < DateTime.now().millisecondsSinceEpoch) {
      await remove(key);
      return null;
    }

    return data;
  }

  @override
  Future<void> put(String key, String value, Duration duration) async {
    await Future.wait([
      SharedPreference.setValue('$key:data', value),
      SharedPreference.setValue('$key:expires_at', DateTime.now().add(duration).millisecondsSinceEpoch.toString()),
      _setLastCachedAt(),
    ]);
  }

  @override
  Future<void> forever(String key, String value) async {
    await Future.wait([
      SharedPreference.setValue('$key:data', value),
      _setLastCachedAt(),
    ]);
  }

  @override
  Future<bool> has(String key) async {
    final data = await SharedPreference.getValue('$key:data');
    if (data == null) return false;

    final expiresAt = await SharedPreference.getValue('$key:expires_at');
    if (expiresAt != null && int.parse(expiresAt) < DateTime.now().millisecondsSinceEpoch) {
      await remove(key);
      return false;
    }

    return true;
  }

  @override
  Future<bool> isExpired(String key) async {
    final expiresAt = await SharedPreference.getValue('$key:expires_at');
    if (expiresAt == null) return false;
    return int.parse(expiresAt) < DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> remove(String key) async {
    await Future.wait([
      SharedPreference.remove('$key:data'),
      SharedPreference.remove('$key:expires_at'),
    ]);
  }

  @override
  Future<void> removeMultiple(RegExp keyPattern) async {
    await SharedPreference.removeMultiple(keyPattern);
  }

  @override
  Future<void> flushAll() async {
    await SharedPreference.removeAll();
  }

  Future<void> _setLastCachedAt() async {
    await SharedPreference.setValue(_lastCachedAtKey, DateTime.now().toString());
  }

  @override
  Future<DateTime?> lastCachedAt() async {
    final value = await SharedPreference.getValue(_lastCachedAtKey);
    if (value == null) return null;
    return DateTime.parse(value);
  }
}
