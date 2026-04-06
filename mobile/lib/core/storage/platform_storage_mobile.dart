import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'platform_storage.dart';

/// Mobile implementation: dùng FlutterSecureStorage (AES encrypted).
class PlatformStorageImpl implements PlatformStorage {
  final FlutterSecureStorage _storage;

  PlatformStorageImpl(this._storage);

  @override
  Future<String?> read({required String key}) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) =>
      _storage.write(key: key, value: value);

  @override
  Future<void> delete({required String key}) => _storage.delete(key: key);

  @override
  Future<void> deleteAll() => _storage.deleteAll();
}
