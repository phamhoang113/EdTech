/// Generic in-memory cache with TTL (Time-To-Live) support.
///
/// Usage:
/// ```dart
/// final cache = AppCache<List<String>>(expiration: Duration(minutes: 5));
/// cache.save(['a', 'b']);
/// final data = cache.data; // returns cached data if still valid
/// ```
class AppCache<T> {
  final Duration expiration;

  T? _data;
  DateTime? _cachedAt;

  AppCache({required this.expiration});

  /// Returns cached data if still valid, otherwise null.
  T? get data => isValid ? _data : null;

  /// Whether the cache contains valid, non-expired data.
  bool get isValid =>
      _data != null &&
      _cachedAt != null &&
      DateTime.now().difference(_cachedAt!) < expiration;

  /// Save data to cache with current timestamp.
  void save(T data) {
    _data = data;
    _cachedAt = DateTime.now();
  }

  /// Clear cached data.
  void clear() {
    _data = null;
    _cachedAt = null;
  }

  /// Get data or fetch from [fetcher] if cache is invalid.
  /// Automatically saves fetched data to cache.
  Future<T> getOrFetch(Future<T> Function() fetcher) async {
    final cached = data;
    if (cached != null) return cached;

    final fresh = await fetcher();
    save(fresh);
    return fresh;
  }
}
