import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/di/injection.dart';

/// Helper mở file download URL trên trình duyệt.
/// Backend trả về relative URL → cần ghép baseUrl.
class FileDownloadHelper {
  FileDownloadHelper._();

  /// Mở URL download trong trình duyệt ngoài.
  static Future<void> openDownloadUrl(BuildContext context, String? relativeUrl) async {
    if (relativeUrl == null || relativeUrl.isEmpty) {
      _showError(context, 'URL download không khả dụng.');
      return;
    }

    try {
      final baseUrl = getIt<DioClient>().dio.options.baseUrl;
      final fullUrl = relativeUrl.startsWith('http')
          ? relativeUrl
          : '$baseUrl$relativeUrl';

      final uri = Uri.parse(fullUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) _showError(context, 'Không thể mở liên kết.');
      }
    } catch (e) {
      if (context.mounted) _showError(context, 'Lỗi tải file: $e');
    }
  }

  static void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}
