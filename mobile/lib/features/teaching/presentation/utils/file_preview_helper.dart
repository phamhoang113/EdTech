import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/di/injection.dart';
import '../../data/models/teaching_models.dart';

/// Helper mở preview file theo loại: ảnh, PDF/doc (WebView), link, video.
class FilePreviewHelper {
  FilePreviewHelper._();

  static Future<void> open(BuildContext context, MaterialModel material) async {
    final baseUrl = getIt<DioClient>().dio.options.baseUrl;
    final rawUrl = material.downloadUrl ?? '';
    final fullUrl = rawUrl.startsWith('http') ? rawUrl : '$baseUrl$rawUrl';

    switch (material.type.toUpperCase()) {
      case 'IMAGE':
        _openImagePreview(context, fullUrl, material.title);
        break;
      case 'VIDEO':
        // Video nặng — mở browser ngoài thay vì nhúng player
        await _launchExternal(context, fullUrl);
        break;
      case 'LINK':
        _openWebPreview(context, rawUrl.isNotEmpty ? rawUrl : fullUrl, material.title);
        break;
      case 'DOCUMENT':
      case 'PDF':
      default:
        // Google Docs Viewer cho PDF / Office files
        final viewerUrl = 'https://docs.google.com/gview?embedded=true&url=${Uri.encodeComponent(fullUrl)}';
        _openWebPreview(context, viewerUrl, material.title);
    }
  }

  static void _openImagePreview(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _ImagePreviewScreen(url: url, title: title),
      ),
    );
  }

  static void _openWebPreview(BuildContext context, String url, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FilePreviewScreen(url: url, title: title),
      ),
    );
  }

  static Future<void> _launchExternal(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Không thể mở file này.')),
      );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WebView Preview Screen (PDF, DOCUMENT, LINK)
// ─────────────────────────────────────────────────────────────────────────────

class FilePreviewScreen extends StatefulWidget {
  final String url;
  final String title;

  const FilePreviewScreen({super.key, required this.url, required this.title});

  @override
  State<FilePreviewScreen> createState() => _FilePreviewScreenState();
}

class _FilePreviewScreenState extends State<FilePreviewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() { _isLoading = true; _hasError = false; }),
        onPageFinished: (_) => setState(() { _isLoading = false; }),
        onWebResourceError: (_) => setState(() { _isLoading = false; _hasError = true; }),
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => _controller.reload(),
            tooltip: 'Tải lại',
          ),
        ],
      ),
      body: Stack(
        children: [
          if (!_hasError) WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Đang tải tài liệu...', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          if (_hasError && !_isLoading)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.broken_image_outlined,
                      size: 56, color: Theme.of(context).colorScheme.error),
                  const SizedBox(height: 12),
                  const Text('Không thể tải tài liệu.',
                      style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () => _controller.reload(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Thử lại'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Image Preview Screen
// ─────────────────────────────────────────────────────────────────────────────

class _ImagePreviewScreen extends StatelessWidget {
  final String url;
  final String title;

  const _ImagePreviewScreen({required this.url, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(title,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: InteractiveViewer(
          minScale: 0.5,
          maxScale: 5.0,
          child: Image.network(
            url,
            fit: BoxFit.contain,
            loadingBuilder: (_, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes!
                      : null,
                  color: Colors.white,
                ),
              );
            },
            errorBuilder: (_, __, ___) => const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.broken_image_outlined, size: 64, color: Colors.white54),
                SizedBox(height: 8),
                Text('Không thể tải ảnh', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
