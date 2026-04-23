

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../data/models/ai_models.dart';
import '../cubit/ai_cubit.dart';

/// Màn hình AI Study Companion — Subject-Room architecture
/// Mỗi môn = 1 phòng học AI riêng biệt (đồng nhất với Web).
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isListening = false;

  static const _primaryColor = Color(0xFF6366F1);
  static const _secondaryColor = Color(0xFF8B5CF6);

  @override
  void initState() {
    super.initState();
    context.read<AiCubit>().init();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => debugPrint('STT onError: $val'),
      onStatus: (val) {
        if (val == 'done' || val == 'notListening') {
           if (mounted) setState(() { _isListening = false; });
        }
      },
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ── Image Picking ─────────────────────────────────────────────────────

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _ImageSourceSheet(
        onGallery: _pickFromGallery,
        onCamera: _pickFromCamera,
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final status = await Permission.photos.request();
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('thư viện ảnh');
      return;
    }
    if (!status.isGranted) return;
    await _pickAndSend(ImageSource.gallery);
  }

  Future<void> _pickFromCamera() async {
    final status = await Permission.camera.request();
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('máy ảnh');
      return;
    }
    if (!status.isGranted) return;
    await _pickAndSend(ImageSource.camera);
  }

  Future<void> _pickAndSend(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1280,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final mimeType =
        picked.path.toLowerCase().endsWith('.png') ? 'image/png' : 'image/jpeg';

    if (!mounted) return;
    context.read<AiCubit>().sendImageMessage(
          imageBytes: bytes,
          mimeType: mimeType,
          content: _textController.text.trim().isNotEmpty
              ? _textController.text.trim()
              : null,
        );
    _textController.clear();
  }

  void _showPermissionDeniedDialog(String permissionName) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Quyền truy cập bị từ chối',
            style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 16)),
        content: Text(
          'Bạn đã từ chối quyền truy cập $permissionName.\n'
          'Vui lòng vào Cài đặt → Ứng dụng để cấp quyền.',
          style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 13,
              height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Hủy',
                style:
                    TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Mở Cài đặt',
                style: TextStyle(
                    color: _primaryColor, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<AiCubit>().sendTextMessage(text);
    _textController.clear();
  }

  void _startListening() async {
    if (!_speechEnabled) return;
    final status = await Permission.microphone.request();
    if (status.isPermanentlyDenied) {
      _showPermissionDeniedDialog('micro');
      return;
    }
    if (!status.isGranted) return;

    await _speechToText.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _textController.text = result.recognizedWords;
          });
        }
      },
      localeId: 'vi_VN',
    );
    if (mounted) {
      setState(() {
        _isListening = true;
      });
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    if (mounted) {
      setState(() {
        _isListening = false;
      });
    }
    if (_textController.text.trim().isNotEmpty) {
      _sendText();
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiCubit, AiState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty ||
            state.status == AiStatus.streaming) _scrollToBottom();
        if (state.errorMessage != null) {
          _showErrorSnackBar(state.errorMessage!);
          context.read<AiCubit>().clearError();
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final subjectIcon = subjectIcons[state.selectedSubject] ?? '📚';

        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: theme.colorScheme.surface,
          appBar: _buildAppBar(context, state, subjectIcon),
          endDrawer: _ConversationDrawer(
            conversations: state.filteredConversations,
            activeConversation: state.activeConversation,
            selectedSubject: state.selectedSubject,
            onSelect: (conv) {
              context.read<AiCubit>().selectConversation(conv);
              Navigator.pop(context);
            },
            onDelete: (convId) =>
                context.read<AiCubit>().deleteConversation(convId),
            onNew: () {
              context.read<AiCubit>().createConversation();
              Navigator.pop(context);
            },
            canCreate: state.canUseAi,
          ),
          body: Column(
            children: [
              _buildSubjectTabs(context, state),
              if (state.subscription?.isTrial == true &&
                  (state.subscription?.trialDaysRemaining ?? 30) <= 7)
                _buildTrialBanner(context, state),
              if (state.activeConversation != null)
                _LearningGoalBar(
                  goal: state.activeConversation?.learningGoal,
                  onSave: (goal) =>
                      context.read<AiCubit>().updateLearningGoal(goal),
                ),
              Expanded(child: _buildBody(context, state)),
              if (!state.isExpired) _buildInputArea(context, state),
            ],
          ),
        );
      },
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────

  AppBar _buildAppBar(BuildContext ctx, AiState state, String icon) {
    final theme = Theme.of(ctx);
    return AppBar(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
                child: Text(icon, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gia sư AI ${state.selectedSubject}',
                    style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 15,
                        fontWeight: FontWeight.w700)),
                Text('Trợ lý học tập của bạn',
                    style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (state.subscription != null) _buildSubBadge(state),
        IconButton(
          icon: Icon(
            state.isTtsEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
            color: state.isTtsEnabled ? _primaryColor : theme.colorScheme.onSurfaceVariant,
            size: 22,
          ),
          tooltip: state.isTtsEnabled ? 'Tắt giọng nói AI' : 'Bật giọng nói AI',
          onPressed: () => context.read<AiCubit>().toggleTts(),
        ),
        IconButton(
          icon: Icon(Icons.forum_outlined,
              color: theme.colorScheme.onSurface, size: 22),
          tooltip: 'Lịch sử hội thoại',
          onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
        ),
      ],
    );
  }

  Widget _buildSubBadge(AiState state) {
    final sub = state.subscription!;
    final isTrial = sub.isTrial;
    final isActive = sub.status == AiSubscriptionStatusEnum.active;

    return Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: isActive
            ? const LinearGradient(
                colors: [Color(0xFFF59E0B), Color(0xFFD97706)])
            : const LinearGradient(colors: [_primaryColor, _secondaryColor]),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isTrial
            ? 'Trial ${sub.trialDaysRemaining ?? 0}d'
            : isActive
                ? 'Premium ✨'
                : 'Hết hạn',
        style: const TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }

  // ── Subject Tabs ──────────────────────────────────────────────────────

  Widget _buildSubjectTabs(BuildContext ctx, AiState state) {
    final theme = Theme.of(ctx);
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(
            bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        children: [
          ...state.activeSubjects.map((subject) => Padding(
                padding: const EdgeInsets.only(right: 6),
                child: _SubjectChip(
                  subject: subject,
                  icon: subjectIcons[subject] ?? '📚',
                  isActive: subject == state.selectedSubject,
                  onTap: () => ctx.read<AiCubit>().selectSubject(subject),
                ),
              )),
          if (state.activeSubjects.length < allSubjects.length)
            _AddSubjectChip(
              onTap: () => _showSubjectPickerSheet(ctx, state),
            ),
        ],
      ),
    );
  }

  // ── Trial Banner ──────────────────────────────────────────────────────

  Widget _buildTrialBanner(BuildContext ctx, AiState state) {
    final theme = Theme.of(ctx);
    final days = state.subscription?.trialDaysRemaining ?? 0;
    final isUrgent = days <= 3;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isUrgent
          ? theme.colorScheme.errorContainer
          : _primaryColor.withValues(alpha: 0.08),
      child: Row(
        children: [
          Icon(Icons.timer_outlined,
              size: 14,
              color: isUrgent ? theme.colorScheme.error : _primaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              days <= 0
                  ? '⚠️ Trial hết hạn hôm nay!'
                  : 'Còn $days ngày dùng thử · Nâng cấp 500.000đ/tháng',
              style: TextStyle(
                color: isUrgent ? theme.colorScheme.error : _primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (isUrgent)
            GestureDetector(
              onTap: () => _showPaywallSheet(ctx),
              child: const Text('Nâng cấp →',
                  style: TextStyle(
                      color: _primaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext ctx, AiState state) {
    if (state.status == AiStatus.loading && state.messages.isEmpty) {
      return const Center(
          child: CircularProgressIndicator(color: _primaryColor));
    }
    if (state.isExpired) {
      return _PaywallBody(onUpgrade: () => _showPaywallSheet(ctx));
    }

    if (state.activeConversation == null || state.messages.isEmpty) {
      return _EmptyState(
        subject: state.selectedSubject,
        subjectIcon: subjectIcons[state.selectedSubject] ?? '📚',
        suggestions: subjectSuggestions[state.selectedSubject] ?? [],
        hasConversation: state.activeConversation != null,
        onSuggestion: (text) {
          if (state.activeConversation == null) {
            ctx.read<AiCubit>().createConversation().then((_) {
              _textController.text = text;
            });
          } else {
            _textController.text = text;
            _sendText();
          }
        },
        onNewConversation: () => ctx.read<AiCubit>().createConversation(),
        canCreate: state.canUseAi,
      );
    }

    final isStreamingOrSending =
        state.status == AiStatus.sending || state.status == AiStatus.streaming;
    final hasStreamingContent =
        state.status == AiStatus.streaming && state.streamingContent.isNotEmpty;

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount:
          state.messages.length + (isStreamingOrSending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          if (hasStreamingContent) {
            return _StreamingBubble(content: state.streamingContent);
          }
          return const _TypingBubble();
        }
        return _MessageBubble(message: state.messages[index]);
      },
    );
  }

  // ── Input Area ────────────────────────────────────────────────────────

  Widget _buildInputArea(BuildContext ctx, AiState state) {
    final theme = Theme.of(ctx);
    final isBusy = state.status == AiStatus.sending ||
        state.status == AiStatus.streaming;
    final hasConv = state.activeConversation != null;

    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 10,
        bottom: MediaQuery.of(ctx).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border:
            Border(top: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasConv)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.canUseAi
                    ? () => ctx.read<AiCubit>().createConversation()
                    : null,
                icon: const Icon(Icons.add, size: 18),
                label: Text('Hội thoại ${state.selectedSubject} mới'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _CircleIconButton(
                  icon: Icons.add_photo_alternate_outlined,
                  onTap: isBusy ? null : _showImageSourceSheet,
                  color: _primaryColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      border: Border.all(
                          color: theme.colorScheme.outlineVariant),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: TextField(
                      controller: _textController,
                      enabled: !isBusy,
                      maxLines: null,
                      style: TextStyle(
                          color: theme.colorScheme.onSurface, fontSize: 14),
                      decoration: InputDecoration(
                        hintText:
                            'Hỏi Gia sư AI ${state.selectedSubject}...',
                        hintStyle: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _sendText(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onLongPressStart: isBusy ? null : (_) => _startListening(),
                  onLongPressEnd: isBusy ? null : (_) => _stopListening(),
                  child: _CircleIconButton(
                    icon: _isListening ? Icons.mic : Icons.mic_none,
                    color: _isListening ? theme.colorScheme.error : _primaryColor,
                    onTap: isBusy ? null : () {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Nhấn giữ biểu tượng mic để nói')),
                      );
                    },
                    filled: _isListening,
                  ),
                ),
                const SizedBox(width: 8),
                _CircleIconButton(
                  icon: isBusy ? null : Icons.send_rounded,
                  loadingWhenNull: true,
                  onTap: isBusy ? null : _sendText,
                  color: _primaryColor,
                  filled: true,
                ),
              ],
            ),
          const SizedBox(height: 4),
          Text(
            'AI có thể nhầm. Hãy kiểm tra lại đáp án quan trọng.',
            style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // ── Sheets ────────────────────────────────────────────────────────────

  void _showSubjectPickerSheet(BuildContext ctx, AiState state) {
    final available =
        allSubjects.where((s) => !state.activeSubjects.contains(s)).toList();
    if (available.isEmpty) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Đã thêm tất cả 9 môn! 🎉')),
      );
      return;
    }
    showModalBottomSheet(
      context: ctx,
      backgroundColor: Theme.of(ctx).colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _SubjectPickerSheet(
        availableSubjects: available,
        onSelect: (subject) {
          ctx.read<AiCubit>().addSubject(subject);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showPaywallSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Theme.of(ctx).colorScheme.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const _PaywallSheet(),
    );
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EXTRACTED WIDGETS — tất cả theme-aware, KHÔNG hard-code màu dark
// ═══════════════════════════════════════════════════════════════════════════

// ── Subject Chip ─────────────────────────────────────────────────────────

class _SubjectChip extends StatelessWidget {
  final String subject;
  final String icon;
  final bool isActive;
  final VoidCallback onTap;

  const _SubjectChip({
    required this.subject,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive
              ? _primaryColor.withValues(alpha: 0.12)
              : theme.colorScheme.surfaceContainer,
          border: Border.all(
            color: isActive
                ? _primaryColor
                : theme.colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 5),
            Text(
              subject,
              style: TextStyle(
                color: isActive
                    ? _primaryColor
                    : theme.colorScheme.onSurfaceVariant,
                fontSize: 12.5,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddSubjectChip extends StatelessWidget {
  final VoidCallback onTap;
  const _AddSubjectChip({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          border: Border.all(
              color: theme.colorScheme.outlineVariant,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 14,
                color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(width: 4),
            Text('Thêm',
                style: TextStyle(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

// ── Conversation Drawer ──────────────────────────────────────────────────

class _ConversationDrawer extends StatelessWidget {
  final List<AiConversation> conversations;
  final AiConversation? activeConversation;
  final String selectedSubject;
  final ValueChanged<AiConversation> onSelect;
  final ValueChanged<String> onDelete;
  final VoidCallback onNew;
  final bool canCreate;

  const _ConversationDrawer({
    required this.conversations,
    required this.activeConversation,
    required this.selectedSubject,
    required this.onSelect,
    required this.onDelete,
    required this.onNew,
    required this.canCreate,
  });

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = subjectIcons[selectedSubject] ?? '📚';

    return Drawer(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 16, 8),
              child: Row(
                children: [
                  Text(icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hội thoại $selectedSubject',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close,
                        color: theme.colorScheme.onSurfaceVariant, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // New button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: canCreate ? onNew : null,
                  icon: const Icon(Icons.add, size: 16),
                  label: Text('Hội thoại $selectedSubject mới'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    textStyle: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),
            Divider(height: 1, color: theme.colorScheme.outlineVariant),

            // List
            Expanded(
              child: conversations.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          'Chưa có hội thoại nào\ncho môn $selectedSubject.\nBấm nút trên để bắt đầu! 🚀',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 13,
                            height: 1.6,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      itemCount: conversations.length,
                      itemBuilder: (ctx, i) {
                        final conv = conversations[i];
                        final isActive =
                            activeConversation?.id == conv.id;
                        return _ConversationTile(
                          conversation: conv,
                          isActive: isActive,
                          onTap: () => onSelect(conv),
                          onDelete: () => onDelete(conv.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final AiConversation conversation;
  final bool isActive;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ConversationTile({
    required this.conversation,
    required this.isActive,
    required this.onTap,
    required this.onDelete,
  });

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: ListTile(
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        selected: isActive,
        selectedTileColor: _primaryColor.withValues(alpha: 0.08),
        leading: Icon(
          Icons.chat_bubble_outline,
          size: 16,
          color: isActive
              ? _primaryColor
              : theme.colorScheme.onSurfaceVariant,
        ),
        title: Text(
          conversation.title.isNotEmpty
              ? conversation.title
              : 'Cuộc trò chuyện',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isActive
                ? _primaryColor
                : theme.colorScheme.onSurface,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete_outline,
              size: 16, color: theme.colorScheme.error),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}

// ── Message Bubble (Markdown rendering) ──────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final AiMessage message;
  const _MessageBubble({required this.message});

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiMessageRole.user;
    final timeStr = DateFormat('HH:mm').format(message.createdAt);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[const _AiAvatar(), const SizedBox(width: 8)],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser
                    ? null
                    : theme.colorScheme.surfaceContainer,
                border: isUser
                    ? null
                    : Border.all(
                        color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User: plain text. AI: markdown rendered
                  if (isUser)
                    SelectableText(
                      message.content,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.55,
                      ),
                    )
                  else
                    MarkdownBody(
                      data: message.content,
                      selectable: true,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          height: 1.55,
                        ),
                        strong: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                        em: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                        h1: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                        h2: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        h3: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                        code: TextStyle(
                          color: _primaryColor,
                          backgroundColor: _primaryColor.withValues(alpha: 0.08),
                          fontFamily: 'monospace',
                          fontSize: 13,
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: theme.colorScheme.outlineVariant),
                        ),
                        codeblockPadding: const EdgeInsets.all(12),
                        listBullet: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                        ),
                        blockquoteDecoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                                color: _primaryColor, width: 3),
                          ),
                        ),
                        blockquotePadding:
                            const EdgeInsets.only(left: 12, top: 4, bottom: 4),
                      ),
                    ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      timeStr,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white.withValues(alpha: 0.5)
                            : theme.colorScheme.onSurfaceVariant,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── AI Avatar ────────────────────────────────────────────────────────────

class _AiAvatar extends StatelessWidget {
  const _AiAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
    );
  }
}

// ── Typing Indicator ─────────────────────────────────────────────────────

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 1))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const _AiAvatar(),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border:
                  Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, _) {
                    final offset =
                        ((_ctrl.value * 3) - i).clamp(0.0, 1.0);
                    final bounce =
                        offset < 0.5 ? offset * 2 : (1 - offset) * 2;
                    return Container(
                      margin:
                          const EdgeInsets.symmetric(horizontal: 2),
                      width: 7,
                      height: 7,
                      transform: Matrix4.translationValues(
                          0, -bounce * 6, 0),
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ── Streaming Bubble (hiển thị AI response real-time) ─────────────────────

class _StreamingBubble extends StatefulWidget {
  final String content;
  const _StreamingBubble({required this.content});

  @override
  State<_StreamingBubble> createState() => _StreamingBubbleState();
}

class _StreamingBubbleState extends State<_StreamingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _cursorCtrl;

  @override
  void initState() {
    super.initState();
    _cursorCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cursorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _AiAvatar(),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                border:
                    Border.all(color: theme.colorScheme.outlineVariant),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  MarkdownBody(
                    data: widget.content,
                    selectable: true,
                    styleSheet: MarkdownStyleSheet(
                      p: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ),
                  // Cursor nhấp nháy
                  AnimatedBuilder(
                    animation: _cursorCtrl,
                    builder: (_, __) => Opacity(
                      opacity: _cursorCtrl.value > 0.5 ? 1.0 : 0.0,
                      child: const Text(
                        '▌',
                        style: TextStyle(
                          color: Color(0xFF6366F1),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty State (subject-specific) ───────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String subject;
  final String subjectIcon;
  final List<String> suggestions;
  final bool hasConversation;
  final ValueChanged<String> onSuggestion;
  final VoidCallback onNewConversation;
  final bool canCreate;

  const _EmptyState({
    required this.subject,
    required this.subjectIcon,
    required this.suggestions,
    required this.hasConversation,
    required this.onSuggestion,
    required this.onNewConversation,
    required this.canCreate,
  });

  static const _primaryColor = Color(0xFF6366F1);
  static const _secondaryColor = Color(0xFF8B5CF6);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                _primaryColor.withValues(alpha: 0.15),
                _secondaryColor.withValues(alpha: 0.15),
              ]),
              borderRadius: BorderRadius.circular(40),
            ),
            child: Center(
                child:
                    Text(subjectIcon, style: const TextStyle(fontSize: 36))),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [_primaryColor, _secondaryColor],
            ).createShader(rect),
            child: Text(
              'Gia sư AI $subject',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hỏi bất kỳ điều gì về môn $subject,\n'
            'hoặc chụp ảnh bài tập để tôi giảng chi tiết!\n'
            'Nói "tôi đang học chương X" để tôi dạy đúng phần bạn cần.',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 24),
          ...suggestions.map(
            (s) => GestureDetector(
              onTap: () => onSuggestion(s),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerLow,
                  border: Border.all(
                      color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.chevron_right,
                        color: _primaryColor, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(s,
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurfaceVariant,
                              fontSize: 13)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (!hasConversation) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: canCreate ? onNewConversation : null,
                icon: const Icon(Icons.add, size: 18),
                label: Text('Bắt đầu học $subject ngay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Paywall Body ─────────────────────────────────────────────────────────

class _PaywallBody extends StatelessWidget {
  final VoidCallback onUpgrade;
  const _PaywallBody({required this.onUpgrade});

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: const Icon(Icons.workspace_premium,
                color: Color(0xFFF59E0B), size: 48),
          ),
          const SizedBox(height: 20),
          Text('Thời gian dùng thử đã hết',
              style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Text(
            'Nâng cấp AI Premium để tiếp tục\nhọc tập không giới hạn cùng Gia sư AI',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.6),
          ),
          const SizedBox(height: 24),
          ...[
            (Icons.camera_alt_outlined, 'Giải bài từ ảnh chụp'),
            (Icons.chat_bubble_outline, 'Hỏi đáp không giới hạn'),
            (Icons.auto_awesome, 'Gia sư AI riêng cho tất cả môn'),
            (Icons.history, 'Lịch sử hội thoại vĩnh viễn'),
          ].map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainer,
                border: Border.all(
                    color: theme.colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(item.$1, color: _primaryColor, size: 18),
                  const SizedBox(width: 10),
                  Text(item.$2,
                      style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onUpgrade,
              icon: const Icon(Icons.workspace_premium, size: 18),
              label: const Text('Nâng cấp 500.000đ / tháng'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Paywall Sheet ────────────────────────────────────────────────────────

class _PaywallSheet extends StatelessWidget {
  const _PaywallSheet();

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Icon(Icons.workspace_premium,
              color: const Color(0xFFF59E0B), size: 48),
          const SizedBox(height: 16),
          Text('Nâng cấp AI Premium',
              style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(
            'Giải bài 24/7, không giới hạn tin nhắn\nhỗ trợ chụp ảnh bài tập với Gia sư AI',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 14,
                height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('500.000đ',
                  style: TextStyle(
                      color: const Color(0xFFF59E0B),
                      fontSize: 32,
                      fontWeight: FontWeight.w900)),
              Text(' / tháng',
                  style: TextStyle(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              border:
                  Border.all(color: theme.colorScheme.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text('📞', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Liên hệ admin hoặc nhắn tin trong ứng dụng để kích hoạt',
                    style: TextStyle(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Đã hiểu',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Subject Picker Sheet ─────────────────────────────────────────────────

class _SubjectPickerSheet extends StatelessWidget {
  final List<String> availableSubjects;
  final ValueChanged<String> onSelect;

  const _SubjectPickerSheet({
    required this.availableSubjects,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, MediaQuery.of(context).padding.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text('Thêm phòng học',
              style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text('Chọn môn học để tạo phòng AI Gia sư riêng',
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: availableSubjects.map((subject) {
              final icon = subjectIcons[subject] ?? '📚';
              return GestureDetector(
                onTap: () => onSelect(subject),
                child: Container(
                  width: (MediaQuery.of(context).size.width - 78) / 3,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                        width: 1.5),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 6),
                      Text(subject,
                          style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 13,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

// ── Image Source Sheet ────────────────────────────────────────────────────

class _ImageSourceSheet extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  const _ImageSourceSheet({
    required this.onGallery,
    required this.onCamera,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text('Chọn ảnh bài tập',
              style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('AI sẽ phân tích và giải thích từng bước',
              style: TextStyle(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13)),
          const SizedBox(height: 20),
          _SourceOption(
            icon: Icons.photo_library_outlined,
            title: 'Thư viện ảnh',
            subtitle: 'Chọn ảnh có sẵn trong điện thoại',
            onTap: () {
              Navigator.pop(context);
              onGallery();
            },
          ),
          const SizedBox(height: 10),
          _SourceOption(
            icon: Icons.camera_alt_outlined,
            title: 'Chụp ảnh',
            subtitle: 'Mở máy ảnh để chụp bài tập ngay',
            onTap: () {
              Navigator.pop(context);
              onCamera();
            },
          ),
        ],
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SourceOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const _primaryColor = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          border:
              Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _primaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _primaryColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                color: theme.colorScheme.onSurfaceVariant, size: 14),
          ],
        ),
      ),
    );
  }
}

// ── Circle Icon Button ───────────────────────────────────────────────────

class _CircleIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final Color color;
  final bool filled;
  final bool loadingWhenNull;

  const _CircleIconButton({
    this.icon,
    this.onTap,
    required this.color,
    this.filled = false,
    this.loadingWhenNull = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: filled ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: icon == null && loadingWhenNull
            ? const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: Colors.white),
                ),
              )
            : Icon(icon, color: filled ? Colors.white : color, size: 20),
      ),
    );
  }
}

// ── Learning Goal Bar ──────────────────────────────────────────────────────

class _LearningGoalBar extends StatefulWidget {
  final String? goal;
  final ValueChanged<String> onSave;

  const _LearningGoalBar({required this.goal, required this.onSave});

  @override
  State<_LearningGoalBar> createState() => _LearningGoalBarState();
}

class _LearningGoalBarState extends State<_LearningGoalBar> {
  bool _editing = false;
  late TextEditingController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.goal ?? '');
  }

  @override
  void didUpdateWidget(_LearningGoalBar old) {
    super.didUpdateWidget(old);
    if (old.goal != widget.goal && !_editing) {
      _ctrl.text = widget.goal ?? '';
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    widget.onSave(_ctrl.text);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasGoal = widget.goal != null && widget.goal!.isNotEmpty;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: _editing ? _buildEditMode(theme) : _buildViewMode(theme, hasGoal),
    );
  }

  Widget _buildViewMode(ThemeData theme, bool hasGoal) {
    return GestureDetector(
      onTap: () {
        _ctrl.text = widget.goal ?? '';
        setState(() => _editing = true);
      },
      child: Row(
        children: [
          Icon(Icons.track_changes,
              size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              hasGoal ? '🎯 ${widget.goal}' : 'Đặt mục tiêu học tập...',
              style: TextStyle(
                fontSize: 12,
                color: hasGoal
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurfaceVariant,
                fontStyle: hasGoal ? FontStyle.normal : FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditMode(ThemeData theme) {
    return Row(
      children: [
        Icon(Icons.track_changes,
            size: 14, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _ctrl,
            autofocus: true,
            maxLength: 500,
            style: TextStyle(
                fontSize: 12, color: theme.colorScheme.onSurface),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              hintText: 'VD: Ôn thi giữa kỳ chương 3-4...',
              hintStyle: TextStyle(
                  fontSize: 12,
                  color: theme.colorScheme.onSurfaceVariant),
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide:
                    BorderSide(color: theme.colorScheme.primary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(
                    color: theme.colorScheme.primary, width: 1.5),
              ),
            ),
            onSubmitted: (_) => _save(),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          height: 28,
          child: FilledButton(
            onPressed: _save,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              textStyle: const TextStyle(fontSize: 11),
            ),
            child: const Text('Lưu'),
          ),
        ),
        const SizedBox(width: 4),
        GestureDetector(
          onTap: () => setState(() => _editing = false),
          child: Icon(Icons.close,
              size: 16, color: theme.colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
