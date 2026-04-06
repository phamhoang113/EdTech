// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:html' as html;

import 'platform_storage.dart';

/// Web implementation: dùng window.localStorage trực tiếp.
/// FlutterSecureStorage v10 có bug trên web (write fails silently).
/// localStorage trên localhost đủ an toàn cho development.
class PlatformStorageImpl implements PlatformStorage {
  static const _prefix = 'fss_'; // namespace tránh xung đột

  // ignore: avoid_unused_constructor_parameters
  PlatformStorageImpl([dynamic _]);

  @override
  Future<String?> read({required String key}) async {
    return html.window.localStorage['$_prefix$key'];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    html.window.localStorage['$_prefix$key'] = value;
  }

  @override
  Future<void> delete({required String key}) async {
    html.window.localStorage.remove('$_prefix$key');
  }

  @override
  Future<void> deleteAll() async {
    final keysToRemove = <String>[];
    for (var i = 0; i < html.window.localStorage.length; i++) {
      final key = html.window.localStorage.keys.elementAt(i);
      if (key.startsWith(_prefix)) {
        keysToRemove.add(key);
      }
    }
    for (final key in keysToRemove) {
      html.window.localStorage.remove(key);
    }
  }
}
