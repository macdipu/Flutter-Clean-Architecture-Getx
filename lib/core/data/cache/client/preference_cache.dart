import '../preference/base_preference.dart';
import '../preference/plain_preference.dart';
import '../preference/secure_preference.dart';
import 'base_cache.dart';

class PreferenceCache extends BaseCache {
  PreferenceCache({
    BasePreference secure = const SecurePreference(),
    BasePreference plain = const PlainPreference(),
  })  : _secure = secure,
        _plain = plain;

  final BasePreference _secure;
  final BasePreference _plain;

  static const String _lastCachedAtKey = 'cache_control:last_cached_at';
  static final RegExp _cacheEntryPattern = RegExp(r'(:data|:expires_at)$');

  BasePreference _store(bool secure) => secure ? _secure : _plain;

  @override
  Future<String?> get(String key, {bool secure = false}) async {
    final store = _store(secure);
    final data = await store.getValue('$key:data');
    if (data == null) return null;

    if (await _isExpiredIn(store, key)) {
      await remove(key, secure: secure);
      return null;
    }

    return data;
  }

  @override
  Future<void> put(String key, String value, Duration duration, {bool secure = false}) async {
    final store = _store(secure);
    await Future.wait([
      store.setValue('$key:data', value),
      store.setValue('$key:expires_at', DateTime.now().add(duration).millisecondsSinceEpoch.toString()),
      _setLastCachedAt(),
    ]);
  }

  @override
  Future<void> forever(String key, String value, {bool secure = false}) async {
    final store = _store(secure);
    await Future.wait([
      store.setValue('$key:data', value),
      store.remove('$key:expires_at'),
      _setLastCachedAt(),
    ]);
  }

  @override
  Future<bool> has(String key, {bool secure = false}) async {
    final store = _store(secure);
    final data = await store.getValue('$key:data');
    if (data == null) return false;

    if (await _isExpiredIn(store, key)) {
      await remove(key, secure: secure);
      return false;
    }

    return true;
  }

  @override
  Future<bool> isExpired(String key, {bool secure = false}) => _isExpiredIn(_store(secure), key);

  Future<bool> _isExpiredIn(BasePreference store, String key) async {
    final raw = await store.getValue('$key:expires_at');
    if (raw == null) return false;
    final expiresAt = int.tryParse(raw);
    // Unparseable expiry means corrupted storage; treat as expired so it gets evicted.
    if (expiresAt == null) return true;
    return expiresAt < DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Future<void> remove(String key, {bool secure = false}) async {
    final store = _store(secure);
    await Future.wait([
      store.remove('$key:data'),
      store.remove('$key:expires_at'),
    ]);
  }

  @override
  Future<void> removeMultiple(RegExp keyPattern) async {
    await Future.wait([
      _secure.removeMultiple(keyPattern),
      _plain.removeMultiple(keyPattern),
    ]);
  }

  @override
  Future<void> clearAppSessionCache() async {
    await Future.wait([
      removeMultiple(_cacheEntryPattern),
      _plain.remove(_lastCachedAtKey),
    ]);
  }

  @override
  Future<void> flushAll() async {
    await Future.wait([
      _secure.removeAll(),
      _plain.removeAll(),
    ]);
  }

  Future<void> _setLastCachedAt() async {
    await _plain.setValue(_lastCachedAtKey, DateTime.now().toString());
  }

  @override
  Future<DateTime?> lastCachedAt() async {
    final value = await _plain.getValue(_lastCachedAtKey);
    if (value == null) return null;
    return DateTime.tryParse(value);
  }
}
