import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

import '../storage/platform_storage.dart';
import '../storage/platform_storage_factory.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @lazySingleton
  PlatformStorage platformStorage(FlutterSecureStorage secureStorage) =>
      createPlatformStorage(secureStorage);
}
