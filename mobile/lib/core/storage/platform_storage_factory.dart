import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'platform_storage.dart';
import 'platform_storage_mobile.dart' if (dart.library.html) 'platform_storage_web.dart';

/// Factory tạo PlatformStorage dựa trên platform:
/// - Web → localStorage (bypass FlutterSecureStorage bug)
/// - Mobile → FlutterSecureStorage (encrypted)
PlatformStorage createPlatformStorage(FlutterSecureStorage secureStorage) {
  return PlatformStorageImpl(secureStorage);
}
