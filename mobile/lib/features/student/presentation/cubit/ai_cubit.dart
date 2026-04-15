import 'dart:typed_data';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/datasources/ai_datasource.dart';
import '../../data/models/ai_models.dart';

// ── State ─────────────────────────────────────────────────────────────────

enum AiStatus { initial, loading, ready, sending, error }

class AiState extends Equatable {
  final AiStatus status;
  final AiSubscriptionStatus? subscription;
  final List<AiConversation> conversations;
  final AiConversation? activeConversation;
  final List<AiMessage> messages;
  final String? errorMessage;

  const AiState({
    this.status = AiStatus.initial,
    this.subscription,
    this.conversations = const [],
    this.activeConversation,
    this.messages = const [],
    this.errorMessage,
  });

  bool get canUseAi => subscription?.canUseAi ?? false;
  bool get isExpired =>
      subscription != null && !(subscription!.canUseAi);

  AiState copyWith({
    AiStatus? status,
    AiSubscriptionStatus? subscription,
    List<AiConversation>? conversations,
    AiConversation? activeConversation,
    bool clearActiveConversation = false,
    List<AiMessage>? messages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AiState(
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      conversations: conversations ?? this.conversations,
      activeConversation: clearActiveConversation
          ? null
          : activeConversation ?? this.activeConversation,
      messages: messages ?? this.messages,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        subscription,
        conversations,
        activeConversation,
        messages,
        errorMessage,
      ];
}

// ── Cubit ─────────────────────────────────────────────────────────────────

class AiCubit extends Cubit<AiState> {
  final AiDataSource _dataSource;

  AiCubit({AiDataSource? dataSource})
      : _dataSource = dataSource ?? AiDataSource(),
        super(const AiState());

  // ── Init ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    emit(state.copyWith(status: AiStatus.loading));
    try {
      final results = await Future.wait([
        _dataSource.getSubscriptionStatus(),
        _dataSource.listConversations(),
      ]);
      final subscription = results[0] as AiSubscriptionStatus;
      final conversations = results[1] as List<AiConversation>;

      AiConversation? active;
      List<AiMessage> messages = [];

      if (conversations.isNotEmpty) {
        active = conversations.first;
        messages = await _dataSource.getMessages(active.id);
      }

      emit(state.copyWith(
        status: AiStatus.ready,
        subscription: subscription,
        conversations: conversations,
        activeConversation: active,
        messages: messages,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AiStatus.error,
        errorMessage: 'Không thể tải dữ liệu AI. Vui lòng thử lại.',
      ));
    }
  }

  // ── Conversation ──────────────────────────────────────────────────────

  Future<void> selectConversation(AiConversation conversation) async {
    if (state.activeConversation?.id == conversation.id) return;

    emit(state.copyWith(
      activeConversation: conversation,
      messages: [],
      status: AiStatus.loading,
    ));

    try {
      final messages = await _dataSource.getMessages(conversation.id);
      emit(state.copyWith(status: AiStatus.ready, messages: messages));
    } catch (e) {
      emit(state.copyWith(
        status: AiStatus.error,
        errorMessage: 'Không tải được tin nhắn.',
      ));
    }
  }

  Future<void> createConversation({String? subject, String? grade}) async {
    if (!state.canUseAi) return;

    try {
      final conv = await _dataSource.createConversation(
        subject: subject,
        grade: grade,
      );
      emit(state.copyWith(
        conversations: [conv, ...state.conversations],
        activeConversation: conv,
        messages: [],
        status: AiStatus.ready,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Không tạo được cuộc trò chuyện.',
      ));
    }
  }

  Future<void> deleteConversation(String conversationId) async {
    try {
      await _dataSource.deleteConversation(conversationId);
      final updated =
          state.conversations.where((c) => c.id != conversationId).toList();
      final isActive = state.activeConversation?.id == conversationId;

      emit(state.copyWith(
        conversations: updated,
        activeConversation: isActive ? (updated.isNotEmpty ? updated.first : null) : state.activeConversation,
        clearActiveConversation: isActive && updated.isEmpty,
        messages: isActive ? [] : state.messages,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Không xóa được cuộc trò chuyện.'));
    }
  }

  // ── Send Message ──────────────────────────────────────────────────────

  Future<void> sendTextMessage(String content) async {
    final conv = state.activeConversation;
    if (conv == null || content.trim().isEmpty) return;
    await _sendMessage(conv.id, content: content);
  }

  Future<void> sendImageMessage({
    required Uint8List imageBytes,
    required String mimeType,
    String? content,
  }) async {
    final conv = state.activeConversation;
    if (conv == null) return;

    final text =
        content?.isNotEmpty == true ? content! : 'Hãy giải bài tập trong ảnh này từng bước chi tiết.';
    await _sendMessage(conv.id,
        content: text, imageBytes: imageBytes, mimeType: mimeType);
  }

  Future<void> _sendMessage(
    String conversationId, {
    required String content,
    Uint8List? imageBytes,
    String? mimeType,
  }) async {
    // Optimistic update
    final optimistic = AiMessage.optimistic(content: content);
    emit(state.copyWith(
      status: AiStatus.sending,
      messages: [...state.messages, optimistic],
      clearError: true,
    ));

    try {
      final AiMessage reply;
      if (imageBytes != null) {
        reply = await _dataSource.sendImageMessage(
          conversationId: conversationId,
          imageBytes: imageBytes,
          imageMimeType: mimeType ?? 'image/jpeg',
          textContent: content,
        );
      } else {
        reply = await _dataSource.sendTextMessage(
          conversationId: conversationId,
          content: content,
        );
      }

      // Reload full list để lấy ID thật từ server
      final messages = await _dataSource.getMessages(conversationId);

      // Refresh subscription usage
      final subscription = await _dataSource.getSubscriptionStatus();

      // Cập nhật title conversation nếu đã thay đổi
      final updatedConvs = await _dataSource.listConversations();

      emit(state.copyWith(
        status: AiStatus.ready,
        messages: messages,
        subscription: subscription,
        conversations: updatedConvs,
      ));
    } catch (e) {
      // Rollback optimistic
      final rollback =
          state.messages.where((m) => m.id != optimistic.id).toList();

      String errorMsg = 'Có lỗi xảy ra. Vui lòng thử lại.';
      if (e.toString().contains('AI_DAILY_LIMIT_REACHED')) {
        errorMsg = 'Bạn đã dùng hết tin nhắn AI hôm nay. Quay lại vào ngày mai.';
      } else if (e.toString().contains('AI_ACCESS_DENIED')) {
        errorMsg = 'Hết thời gian dùng thử. Nâng cấp AI Premium để tiếp tục.';
      }

      emit(state.copyWith(
        status: AiStatus.error,
        messages: rollback,
        errorMessage: errorMsg,
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(clearError: true, status: AiStatus.ready));
  }
}
