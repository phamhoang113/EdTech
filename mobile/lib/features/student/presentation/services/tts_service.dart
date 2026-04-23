import 'package:flutter_tts/flutter_tts.dart';

/// Service quản lý Text-to-Speech — AI đọc response bằng giọng nói.
/// Chạy hoàn toàn on-device, chi phí = $0.
class TtsService {
  final FlutterTts _tts = FlutterTts();

  bool _isEnabled = false;
  bool _isSpeaking = false;

  bool get isEnabled => _isEnabled;
  bool get isSpeaking => _isSpeaking;

  /// Callback khi TTS hoàn tất đọc
  void Function()? onComplete;

  TtsService() {
    _initTts();
  }

  Future<void> _initTts() async {
    // Cấu hình giọng Việt Nam
    await _tts.setLanguage('vi-VN');
    await _tts.setSpeechRate(0.5); // Tốc độ vừa phải cho giảng dạy
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onComplete?.call();
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
    });
  }

  /// Bật/tắt chế độ đọc tự động
  void toggle() {
    _isEnabled = !_isEnabled;
    if (!_isEnabled && _isSpeaking) {
      stop();
    }
  }

  /// Đọc nội dung AI response
  Future<void> speak(String text) async {
    if (!_isEnabled || text.trim().isEmpty) return;

    // Làm sạch markdown (bỏ ký hiệu không cần đọc)
    final cleanText = _cleanForSpeech(text);
    if (cleanText.isEmpty) return;

    _isSpeaking = true;
    await _tts.speak(cleanText);
  }

  /// Dừng đọc
  Future<void> stop() async {
    _isSpeaking = false;
    await _tts.stop();
  }

  /// Loại bỏ markdown syntax, giữ nội dung đọc được
  String _cleanForSpeech(String text) {
    return text
        // Bỏ heading markers
        .replaceAll(RegExp(r'#{1,6}\s'), '')
        // Bỏ bold/italic markers
        .replaceAll(RegExp(r'\*{1,3}'), '')
        .replaceAll(RegExp(r'_{1,3}'), '')
        // Bỏ bullet points
        .replaceAll(RegExp(r'^[-*+]\s', multiLine: true), '')
        // Bỏ numbered list markers
        .replaceAll(RegExp(r'^\d+\.\s', multiLine: true), '')
        // Bỏ code blocks
        .replaceAll(RegExp(r'```[\s\S]*?```'), '')
        .replaceAll(RegExp(r'`[^`]+`'), '')
        // Bỏ link syntax, giữ text
        .replaceAll(RegExp(r'\[([^\]]+)\]\([^)]+\)'), r'$1')
        // Bỏ emoji (giữ lại cũng được, TTS sẽ bỏ qua)
        .replaceAll(RegExp(r'[📐📖🌍⚡🧪🧬📜🗺️💻📚🎯🔢✅❌⚠️🌟👉]'), '')
        // Collapse whitespace
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  void dispose() {
    stop();
    _tts.stop();
  }
}
