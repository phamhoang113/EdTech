import 'dart:async';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/datasources/ai_datasource.dart';
import '../../data/models/ai_models.dart';
import '../services/tts_service.dart';

// ── Constants (đồng nhất với Web) ────────────────────────────────────────

const List<String> defaultSubjects = ['Toán', 'Văn', 'Anh'];

const List<String> allSubjects = [
  'Toán', 'Văn', 'Anh', 'Lý', 'Hóa', 'Sinh', 'Sử', 'Địa', 'Tin',
];

const Map<String, String> subjectIcons = {
  'Toán': '📐', 'Văn': '📖', 'Anh': '🌍',
  'Lý': '⚡', 'Hóa': '🧪', 'Sinh': '🧬',
  'Sử': '📜', 'Địa': '🗺️', 'Tin': '💻',
};

const Map<String, List<String>> subjectSuggestions = {
  'Toán': ['Giải phương trình bậc 2 chi tiết', 'Đạo hàm là gì?', 'Cách tính tích phân'],
  'Văn': ['Phân tích nhân vật Chí Phèo', 'Cách làm bài nghị luận xã hội', 'Tìm luận điểm chính'],
  'Anh': ['Explain Present Perfect vs Past Simple', 'Common English mistakes', 'How to write an essay'],
  'Lý': ['Giải thích định luật Newton', 'Bài toán chuyển động ném xiên', 'Mạch điện RLC'],
  'Hóa': ['Cân bằng phương trình hóa học', 'Bài tập về mol', 'Chuỗi phản ứng hữu cơ'],
  'Sinh': ['Gen trội gen lặn là gì?', 'Bài tập di truyền', 'Quá trình nguyên phân'],
  'Sử': ['Diễn biến cách mạng tháng 8', 'So sánh 2 cuộc kháng chiến', 'Ý nghĩa chiến thắng ĐBP'],
  'Địa': ['Phân tích biểu đồ dân số', 'So sánh vùng kinh tế', 'Đặc điểm khí hậu VN'],
  'Tin': ['Thuật toán sắp xếp nổi bọt', 'Bài tập Python cơ bản', 'Cấu trúc dữ liệu mảng'],
};

const int trialDailyLimit = 15;

const String _storageKey = 'edtech_ai_subjects';

// ── State ─────────────────────────────────────────────────────────────────

enum AiStatus { initial, loading, ready, sending, streaming, error }

class AiState extends Equatable {
  final AiStatus status;
  final AiSubscriptionStatus? subscription;
  final List<AiConversation> allConversations;
  final AiConversation? activeConversation;
  final List<AiMessage> messages;
  final String? errorMessage;
  final String selectedSubject;
  final List<String> activeSubjects;
  final String streamingContent;
  final bool isTtsEnabled;

  const AiState({
    this.status = AiStatus.initial,
    this.subscription,
    this.allConversations = const [],
    this.activeConversation,
    this.messages = const [],
    this.errorMessage,
    this.selectedSubject = 'Toán',
    this.activeSubjects = const ['Toán', 'Văn', 'Anh'],
    this.streamingContent = '',
    this.isTtsEnabled = false,
  });

  bool get canUseAi => subscription?.canUseAi ?? false;

  bool get isExpired => subscription != null && !(subscription!.canUseAi);

  /// Conversations lọc theo môn đang chọn
  List<AiConversation> get filteredConversations =>
      allConversations.where((c) => c.subject == selectedSubject).toList();

  AiState copyWith({
    AiStatus? status,
    AiSubscriptionStatus? subscription,
    List<AiConversation>? allConversations,
    AiConversation? activeConversation,
    bool clearActiveConversation = false,
    List<AiMessage>? messages,
    String? errorMessage,
    bool clearError = false,
    String? selectedSubject,
    List<String>? activeSubjects,
    String? streamingContent,
    bool? isTtsEnabled,
  }) {
    return AiState(
      status: status ?? this.status,
      subscription: subscription ?? this.subscription,
      allConversations: allConversations ?? this.allConversations,
      activeConversation: clearActiveConversation
          ? null
          : activeConversation ?? this.activeConversation,
      messages: messages ?? this.messages,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      selectedSubject: selectedSubject ?? this.selectedSubject,
      activeSubjects: activeSubjects ?? this.activeSubjects,
      streamingContent: streamingContent ?? this.streamingContent,
      isTtsEnabled: isTtsEnabled ?? this.isTtsEnabled,
    );
  }

  @override
  List<Object?> get props => [
        status, subscription, allConversations, activeConversation,
        messages, errorMessage, selectedSubject, activeSubjects,
        streamingContent, isTtsEnabled,
      ];
}

// ── Cubit ─────────────────────────────────────────────────────────────────

class AiCubit extends Cubit<AiState> {
  final AiDataSource _dataSource;
  final TtsService _ttsService = TtsService();

  AiCubit({AiDataSource? dataSource})
      : _dataSource = dataSource ?? AiDataSource(),
        super(const AiState());

  // ── Init ──────────────────────────────────────────────────────────────

  Future<void> init() async {
    emit(state.copyWith(status: AiStatus.loading));
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSubjects = _loadActiveSubjects(prefs);
      final selectedSubject =
          savedSubjects.isNotEmpty ? savedSubjects.first : 'Toán';

      final results = await Future.wait([
        _dataSource.getSubscriptionStatus(),
        _dataSource.listConversations(),
      ]);
      final subscription = results[0] as AiSubscriptionStatus;
      final conversations = results[1] as List<AiConversation>;

      // Auto-select conversation đầu tiên của môn đang chọn
      final filtered =
          conversations.where((c) => c.subject == selectedSubject).toList();
      AiConversation? active;
      List<AiMessage> messages = [];
      if (filtered.isNotEmpty) {
        active = filtered.first;
        messages = await _dataSource.getMessages(active.id);
      }

      emit(state.copyWith(
        status: AiStatus.ready,
        subscription: subscription,
        allConversations: conversations,
        activeConversation: active,
        clearActiveConversation: active == null,
        messages: messages,
        selectedSubject: selectedSubject,
        activeSubjects: savedSubjects,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: AiStatus.error,
        errorMessage: 'Không thể tải dữ liệu AI. Vui lòng thử lại.',
      ));
    }
  }

  // ── Subject Management ────────────────────────────────────────────────

  Future<void> selectSubject(String subject) async {
    if (subject == state.selectedSubject) return;

    final filtered =
        state.allConversations.where((c) => c.subject == subject).toList();

    if (filtered.isNotEmpty) {
      emit(state.copyWith(
        selectedSubject: subject,
        activeConversation: filtered.first,
        messages: [],
        status: AiStatus.loading,
      ));
      try {
        final messages = await _dataSource.getMessages(filtered.first.id);
        emit(state.copyWith(status: AiStatus.ready, messages: messages));
      } catch (_) {
        emit(state.copyWith(status: AiStatus.ready));
      }
    } else {
      emit(state.copyWith(
        selectedSubject: subject,
        clearActiveConversation: true,
        messages: [],
        status: AiStatus.ready,
      ));
    }
  }

  Future<void> addSubject(String subject) async {
    if (state.activeSubjects.contains(subject)) return;
    final updated = [...state.activeSubjects, subject];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_storageKey, updated);

    emit(state.copyWith(activeSubjects: updated));
    await selectSubject(subject);
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

  Future<void> createConversation() async {
    if (!state.canUseAi) return;

    try {
      final conv = await _dataSource.createConversation(
        subject: state.selectedSubject,
      );
      emit(state.copyWith(
        allConversations: [conv, ...state.allConversations],
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
          state.allConversations.where((c) => c.id != conversationId).toList();
      final isActive = state.activeConversation?.id == conversationId;

      if (isActive) {
        final filtered =
            updated.where((c) => c.subject == state.selectedSubject).toList();
        emit(state.copyWith(
          allConversations: updated,
          activeConversation:
              filtered.isNotEmpty ? filtered.first : null,
          clearActiveConversation: filtered.isEmpty,
          messages: [],
        ));
      } else {
        emit(state.copyWith(allConversations: updated));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Không xóa được cuộc trò chuyện.'));
    }
  }

  Future<void> updateLearningGoal(String goal) async {
    final conv = state.activeConversation;
    if (conv == null) return;

    try {
      final updated = await _dataSource.updateConversation(
        conv.id,
        learningGoal: goal.trim().isEmpty ? '' : goal.trim(),
      );
      final updatedList = state.allConversations
          .map((c) => c.id == updated.id ? updated : c)
          .toList();
      emit(state.copyWith(
        activeConversation: updated,
        allConversations: updatedList,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Không cập nhật được mục tiêu.'));
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

    final text = content?.isNotEmpty == true
        ? content!
        : 'Hãy giải bài tập trong ảnh này từng bước chi tiết.';
    await _sendMessage(conv.id,
        content: text, imageBytes: imageBytes, mimeType: mimeType);
  }

  StreamSubscription<String>? _streamSubscription;

  Future<void> _sendMessage(
    String conversationId, {
    required String content,
    Uint8List? imageBytes,
    String? mimeType,
  }) async {
    final optimistic = AiMessage.optimistic(content: content);
    emit(state.copyWith(
      status: AiStatus.sending,
      messages: [...state.messages, optimistic],
      streamingContent: '',
      clearError: true,
    ));

    try {
      // Sử dụng SSE Streaming
      final stream = _dataSource.sendMessageStream(
        conversationId: conversationId,
        content: content,
        imageBytes: imageBytes,
        imageMimeType: mimeType,
      );

      final completer = Completer<void>();

      _streamSubscription = stream.listen(
        (chunk) {
          // Emit từng chunk text real-time
          emit(state.copyWith(
            status: AiStatus.streaming,
            streamingContent: state.streamingContent + chunk,
          ));
        },
        onDone: () async {
          // Stream hoàn tất → refresh messages từ server
          try {
            final messages = await _dataSource.getMessages(conversationId);
            final subscription = await _dataSource.getSubscriptionStatus();
            final updatedConvs = await _dataSource.listConversations();

            emit(state.copyWith(
              status: AiStatus.ready,
              messages: messages,
              subscription: subscription,
              allConversations: updatedConvs,
              streamingContent: '',
            ));

            // Auto-đọc response cuối cùng bằng TTS
            if (_ttsService.isEnabled && messages.isNotEmpty) {
              final lastMsg = messages.last;
              if (lastMsg.role == 'assistant') {
                _ttsService.speak(lastMsg.content);
              }
            }
          } catch (_) {
            emit(state.copyWith(
              status: AiStatus.ready,
              streamingContent: '',
            ));
          }
          completer.complete();
        },
        onError: (e) {
          final rollback =
              state.messages.where((m) => m.id != optimistic.id).toList();

          String errorMsg = 'Có lỗi xảy ra. Vui lòng thử lại.';
          if (e.toString().contains('AI_DAILY_LIMIT_REACHED')) {
            errorMsg =
                'Bạn đã dùng hết $trialDailyLimit tin nhắn AI hôm nay. Quay lại vào ngày mai.';
          } else if (e.toString().contains('AI_ACCESS_DENIED')) {
            errorMsg =
                'Hết thời gian dùng thử. Nâng cấp AI Premium để tiếp tục.';
          }

          emit(state.copyWith(
            status: AiStatus.error,
            messages: rollback,
            errorMessage: errorMsg,
            streamingContent: '',
          ));
          completer.complete();
        },
      );

      await completer.future;
    } catch (e) {
      final rollback =
          state.messages.where((m) => m.id != optimistic.id).toList();

      emit(state.copyWith(
        status: AiStatus.error,
        messages: rollback,
        errorMessage: 'Có lỗi xảy ra. Vui lòng thử lại.',
        streamingContent: '',
      ));
    }
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    _ttsService.dispose();
    return super.close();
  }

  void clearError() {
    emit(state.copyWith(clearError: true, status: AiStatus.ready));
  }

  /// Bật/tắt TTS — AI đọc response bằng giọng nói
  void toggleTts() {
    _ttsService.toggle();
    emit(state.copyWith(isTtsEnabled: _ttsService.isEnabled));
  }

  /// Dừng TTS đang đọc
  void stopTts() {
    _ttsService.stop();
  }

  // ── Persistence ───────────────────────────────────────────────────────

  List<String> _loadActiveSubjects(SharedPreferences prefs) {
    final saved = prefs.getStringList(_storageKey);
    if (saved != null && saved.isNotEmpty) {
      return saved.where((s) => allSubjects.contains(s)).toList();
    }
    return List.from(defaultSubjects);
  }
}
