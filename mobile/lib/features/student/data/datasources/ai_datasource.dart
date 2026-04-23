import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../models/ai_models.dart';

/// REST API datasource cho module AI Assistance.
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

  /// Cập nhật conversation (mục tiêu học tập).
  Future<AiConversation> updateConversation(
    String conversationId, {
    String? learningGoal,
  }) async {
    final response = await _dio.patch(
      '/api/v1/ai/conversations/$conversationId',
      data: {
        if (learningGoal != null) 'learningGoal': learningGoal,
      },
    );
    return AiConversation.fromJson(
      response.data['data'] as Map<String, dynamic>,
    );
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

  /// Gửi message với SSE streaming — nhận AI response từng chunk real-time.
  /// Trả về Stream<String> mỗi text chunk.
  Stream<String> sendMessageStream({
    required String conversationId,
    String? content,
    List<int>? imageBytes,
    String? imageMimeType,
  }) async* {
    final data = <String, dynamic>{};
    if (content != null) data['content'] = content;
    if (imageBytes != null) {
      data['imageBase64'] = base64Encode(imageBytes);
      data['imageMimeType'] = imageMimeType ?? 'image/jpeg';
      data['content'] ??= 'Hãy giải bài tập trong ảnh này từng bước chi tiết.';
    }

    final response = await _dio.post<ResponseBody>(
      '/api/v1/ai/conversations/$conversationId/messages/stream',
      data: data,
      options: Options(
        responseType: ResponseType.stream,
        receiveTimeout: const Duration(seconds: 120),
      ),
    );

    final stream = response.data?.stream;
    if (stream == null) return;

    String buffer = '';
    await for (final bytes in stream) {
      buffer += utf8.decode(bytes);

      final lines = buffer.split('\n');
      buffer = lines.removeLast(); // giữ lại dòng chưa hoàn chỉnh

      String currentEvent = '';

      for (final line in lines) {
        final trimmed = line.trim();

        if (trimmed.startsWith('event:')) {
          currentEvent = trimmed.substring(6).trim();
        } else if (trimmed.startsWith('data:')) {
          final data = trimmed.substring(5).trim();

          if (currentEvent == 'chunk' && data.isNotEmpty) {
            yield data;
          } else if (currentEvent == 'error' && data.isNotEmpty) {
            throw Exception(data);
          }
          // 'done' event → stream kết thúc tự nhiên
        }
      }
    }
  }
}
