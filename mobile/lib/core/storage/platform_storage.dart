import 'dart:async';

/// Abstract interface cho platform-aware storage.
/// Web: dùng localStorage (window.localStorage)
/// Mobile: dùng FlutterSecureStorage (encrypted)
abstract class PlatformStorage {
  Future<String?> read({required String key});
  Future<void> write({required String key, required String value});
  Future<void> delete({required String key});
  Future<void> deleteAll();
}
