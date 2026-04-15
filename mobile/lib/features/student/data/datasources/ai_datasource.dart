import 'dart:convert';
import 'package:dio/dio.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../models/ai_models.dart';

/// REST API datasource cho module AI Study Companion.
class AiDataSource {
  final _dio = getIt<DioClient>().dio;

  // ═══════════ SUBSCRIPTION ═══════════

  /// Lấy trạng thái subscription — tự kích hoạt trial nếu chưa có.
  Future<AiSubscriptionStatus> getSubscriptionStatus() async {
    final response = await _dio.get('/api/v1/ai/subscription/status');
    return AiSubscriptionStatus.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  // ═══════════ CONVERSATIONS ═══════════

  /// Danh sách conversations của HS.
  Future<List<AiConversation>> listConversations() async {
    final response = await _dio.get('/api/v1/ai/conversations');
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => AiConversation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Tạo conversation mới.
  Future<AiConversation> createConversation({
    String? subject,
    String? grade,
  }) async {
    final response = await _dio.post(
      '/api/v1/ai/conversations',
      data: {
        if (subject != null) 'subject': subject,
        if (grade != null) 'grade': grade,
      },
    );
    return AiConversation.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
  }

  /// Xóa conversation.
  Future<void> deleteConversation(String conversationId) async {
    await _dio.delete('/api/v1/ai/conversations/$conversationId');
  }

  // ═══════════ MESSAGES ═══════════

  /// Lịch sử tin nhắn của 1 conversation.
  Future<List<AiMessage>> getMessages(String conversationId) async {
    final response =
        await _dio.get('/api/v1/ai/conversations/$conversationId/messages');
    final list = response.data['data'] as List<dynamic>? ?? [];
    return list
        .map((e) => AiMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Gửi tin nhắn text.
  Future<AiMessage> sendTextMessage({
    required String conversationId,
    required String content,
  }) async {
    final response = await _dio.post(
      '/api/v1/ai/conversations/$conversationId/messages',
      data: {'content': content},
      options: Options(receiveTimeout: const Duration(seconds: 60)),
    );
    return AiMessage.fromJson(response.data['data'] as Map<String, dynamic>);
  }

  /// Gửi ảnh + text (camera solver).
  /// [imageBytes] = raw bytes của ảnh, sẽ được chuyển về base64.
  Future<AiMessage> sendImageMessage({
    required String conversationId,
    required List<int> imageBytes,
    required String imageMimeType,
    String? textContent,
  }) async {
    final base64Image = base64Encode(imageBytes);
    final response = await _dio.post(
      '/api/v1/ai/conversations/$conversationId/messages',
      data: {
        'content': textContent ??
            'Hãy giải thích bài tập trong ảnh này từng bước chi tiết.',
        'imageBase64': base64Image,
        'imageMimeType': imageMimeType,
      },
      options: Options(receiveTimeout: const Duration(seconds: 90)),
    );
    return AiMessage.fromJson(response.data['data'] as Map<String, dynamic>);
  }
}
