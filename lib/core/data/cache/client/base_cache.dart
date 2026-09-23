/// Pass `secure: true` for secrets (tokens, user info); the same flag must be
/// used on read and write, since secure and plain entries live in separate stores.
abstract class BaseCache {
  Future<void> put(String key, String value, Duration duration, {bool secure = false});

  Future<void> forever(String key, String value, {bool secure = false});

  Future<String?> get(String key, {bool secure = false});

  Future<bool> has(String key, {bool secure = false});

  Future<bool> doesNotHave(String key, {bool secure = false}) async => !await has(key, secure: secure);

  Future<bool> isExpired(String key, {bool secure = false});

  Future<void> remove(String key, {bool secure = false});

  Future<void> removeMultiple(RegExp keyPattern);

  /// Removes only entries written through this cache; other data sharing the
  /// same stores (e.g. app settings) survives. Use this on logout.
  Future<void> clearAppSessionCache();

  /// DANGEROUS: wipes every key in the underlying stores, including data this
  /// cache does not own (theme, locale, other settings).
  Future<void> flushAll();

  Future<DateTime?> lastCachedAt();
}
