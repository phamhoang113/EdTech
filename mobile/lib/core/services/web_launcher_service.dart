import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/app_config.dart';
import '../storage/platform_storage.dart';

/// Service mở web platform với token an toàn.
///
/// Sử dụng URL **hash fragment** (`#token=xxx`) thay vì query parameter
/// (`?token=xxx`) để ngăn token bị log bởi:
///   - Web server access logs
///   - Proxy logs / CDN
///   - Browser referrer headers
///
/// Hash fragment KHÔNG bao giờ được gửi lên server trong HTTP request,
/// chỉ client-side JavaScript đọc được → an toàn hơn query param.
@lazySingleton
class WebLauncherService {
  final PlatformStorage _storage;

  WebLauncherService(this._storage);

  /// Mở web path với token + user info truyền qua hash fragment.
  ///
  /// URL cuối cùng:
  ///   `https://giasutinhhoa.com/parent/dashboard#token=abc&refreshToken=xyz&fullName=Test&role=PARENT`
  Future<void> openWithToken(String path) async {
    final token = await _storage.read(key: 'accessToken');
    final refreshToken = await _storage.read(key: 'refreshToken');
    final fullName = await _storage.read(key: 'userFullName');
    final role = await _storage.read(key: 'userRole');

    // Debug: log ở cả terminal và browser console
    debugPrint('[WebLauncher] token=${token != null ? '${token.substring(0, 20)}...' : 'NULL'}');
    debugPrint('[WebLauncher] fullName=$fullName, role=$role');

    if (token == null) {
      debugPrint('[WebLauncher] ⚠️ TOKEN IS NULL — opening without auth');
      final url = Uri.parse('${AppConfig.webBaseUrl}$path');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      }
      return;
    }

    // Encode fullName để tránh lỗi ký tự đặc biệt trong URL
    final encodedName = Uri.encodeComponent(fullName ?? '');
    final fragment = 'token=$token'
        '&refreshToken=${refreshToken ?? ''}'
        '&fullName=$encodedName'
        '&role=${role ?? ''}';
    final urlString = '${AppConfig.webBaseUrl}$path#$fragment';

    debugPrint('[WebLauncher] Opening URL (length=${urlString.length}): ${urlString.substring(0, 80)}...');

    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  /// Mở web URL đơn giản (không truyền token).
  Future<void> open(String path) async {
    final url = Uri.parse('${AppConfig.webBaseUrl}$path');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
