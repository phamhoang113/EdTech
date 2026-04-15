import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../data/models/ai_models.dart';
import '../cubit/ai_cubit.dart';

/// Màn hình AI Study Companion — chat interface cho học sinh.
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  final _imagePicker = ImagePicker();

  // Design tokens
  static const _primaryColor = Color(0xFF6366F1);
  static const _secondaryColor = Color(0xFF8B5CF6);
  static const _bgColor = Color(0xFF0F1117);
  static const _surfaceColor = Color(0xFF161B27);
  static const _cardColor = Color(0xFF1A1F2E);
  static const _borderColor = Color(0xFF2D3748);
  static const _textMuted = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    context.read<AiCubit>().init();
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

  Future<void> _pickAndSendImage() async {
    final picked = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
      maxWidth: 1280,
    );
    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final mimeType = File(picked.path).path.endsWith('.png')
        ? 'image/png'
        : 'image/jpeg';

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

  void _sendText() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    context.read<AiCubit>().sendTextMessage(text);
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AiCubit, AiState>(
      listener: (context, state) {
        if (state.messages.isNotEmpty) _scrollToBottom();
        if (state.errorMessage != null) {
          _showErrorSnackBar(state.errorMessage!);
          context.read<AiCubit>().clearError();
        }
        if (state.isExpired) {
          _showPaywallSheet(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _bgColor,
          appBar: _buildAppBar(context, state),
          body: Column(
            children: [
              // Trial banner
              if (state.subscription?.isTrial == true &&
                  (state.subscription?.trialDaysRemaining ?? 30) <= 7)
                _buildTrialBanner(state),
              // Main area
              Expanded(child: _buildBody(context, state)),
              // Input
              if (!state.isExpired) _buildInputArea(context, state),
            ],
          ),
        );
      },
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────

  AppBar _buildAppBar(BuildContext context, AiState state) {
    return AppBar(
      backgroundColor: _surfaceColor,
      elevation: 0,
      title: Row(
        children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [_primaryColor, _secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AI Study Companion',
                  style: TextStyle(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
              Text('Gia sư AI của bạn',
                  style: TextStyle(color: _textMuted, fontSize: 11)),
            ],
          ),
        ],
      ),
      actions: [
        // Subscription badge
        if (state.subscription != null)
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              gradient: state.subscription!.status == AiSubscriptionStatusEnum.active
                  ? const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)])
                  : const LinearGradient(colors: [_primaryColor, _secondaryColor]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              state.subscription!.isTrial
                  ? 'Trial ${state.subscription!.trialDaysRemaining ?? 0}d'
                  : state.subscription!.status == AiSubscriptionStatusEnum.active
                      ? 'Premium'
                      : 'Hết hạn',
              style: const TextStyle(
                  color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
            ),
          ),
        // New conversation
        IconButton(
          icon: const Icon(Icons.add_comment_outlined, color: Colors.white),
          onPressed: () => _showNewConversationSheet(context, state),
        ),
      ],
    );
  }

  // ── Trial Banner ──────────────────────────────────────────────────────

  Widget _buildTrialBanner(AiState state) {
    final days = state.subscription?.trialDaysRemaining ?? 0;
    final isUrgent = days <= 3;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isUrgent
          ? const Color(0xFFF59E0B).withOpacity(0.1)
          : _primaryColor.withOpacity(0.1),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: isUrgent ? const Color(0xFFFBBF24) : _primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            days <= 0
                ? 'Trial hết hạn hôm nay!'
                : 'Còn $days ngày dùng thử miễn phí',
            style: TextStyle(
              color: isUrgent ? const Color(0xFFFBBF24) : _primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton(
            onPressed: () => _showPaywallSheet(context),
            child: const Text('Nâng cấp',
                style: TextStyle(
                    color: _primaryColor, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  // ── Body ──────────────────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, AiState state) {
    if (state.status == AiStatus.loading && state.messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: _primaryColor),
      );
    }

    if (state.isExpired) {
      return _buildPaywallBody();
    }

    if (state.messages.isEmpty) {
      return _buildEmptyState(context, state);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: state.messages.length + (state.status == AiStatus.sending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == state.messages.length) {
          // Typing indicator
          return _buildTypingIndicator();
        }
        return _MessageBubble(message: state.messages[index]);
      },
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context, AiState state) {
    final suggestions = [
      '📐 Giải phương trình bậc 2',
      '📖 Phân tích nhân vật Chí Phèo',
      '⚗️ Giải thích phản ứng oxi hóa',
      '📊 Tính đạo hàm bước cơ bản',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _primaryColor.withOpacity(0.2),
                  _secondaryColor.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Icon(Icons.auto_awesome, color: _primaryColor, size: 36),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (rect) => const LinearGradient(
              colors: [_primaryColor, _secondaryColor],
            ).createShader(rect),
            child: const Text(
              'AI Study Companion',
              style: TextStyle(
                  color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hỏi bất kỳ điều gì, hoặc\nchụp ảnh bài tập để AI giải từng bước',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textMuted, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),
          ...suggestions.map((s) => _SuggestionChip(
                text: s,
                onTap: () {
                  _textController.text = s.replaceAll(RegExp(r'^[^\s]+ '), '');
                  _sendText();
                },
              )),
        ],
      ),
    );
  }

  // ── Paywall ───────────────────────────────────────────────────────────

  Widget _buildPaywallBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Container(
            width: 96, height: 96,
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(48),
            ),
            child: const Icon(Icons.workspace_premium,
                color: Color(0xFFF59E0B), size: 48),
          ),
          const SizedBox(height: 20),
          const Text(
            'Thời gian dùng thử đã hết',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          const Text(
            'Nâng cấp AI Premium để tiếp tục\nhọc tập cùng AI Tutor không giới hạn',
            textAlign: TextAlign.center,
            style: TextStyle(color: _textMuted, fontSize: 14, height: 1.6),
          ),
          const SizedBox(height: 24),
          ...[
            (Icons.camera_alt_outlined, 'Giải bài từ ảnh chụp'),
            (Icons.chat_bubble_outline, 'Hỏi đáp không giới hạn'),
            (Icons.history, 'Lưu lịch sử hội thoại),'),
          ].map(
            (item) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _cardColor,
                border: Border.all(color: _borderColor),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(item.$1, color: _primaryColor, size: 18),
                  const SizedBox(width: 10),
                  Text(item.$2,
                      style: const TextStyle(color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showPaywallSheet(context),
              icon: const Icon(Icons.workspace_premium, size: 18),
              label: const Text('Nâng cấp 200.000đ / tháng'),
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

  // ── Input Area ────────────────────────────────────────────────────────

  Widget _buildInputArea(BuildContext context, AiState state) {
    final isSending = state.status == AiStatus.sending;
    final hasConv = state.activeConversation != null;

    return Container(
      padding: EdgeInsets.only(
        left: 12, right: 12, top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: BoxDecoration(
        color: _surfaceColor,
        border: Border(top: BorderSide(color: _borderColor)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!hasConv)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: state.canUseAi
                    ? () => context.read<AiCubit>().createConversation()
                    : null,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Bắt đầu cuộc trò chuyện'),
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
                // Camera button
                _CircleIconButton(
                  icon: Icons.camera_alt_outlined,
                  onTap: isSending ? null : _pickAndSendImage,
                  color: _primaryColor,
                ),
                const SizedBox(width: 8),
                // Text input
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: _cardColor,
                      border: Border.all(color: _borderColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: TextField(
                      controller: _textController,
                      enabled: !isSending,
                      maxLines: null,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Nhập câu hỏi...',
                        hintStyle: TextStyle(color: _textMuted),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onSubmitted: (_) => _sendText(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                _CircleIconButton(
                  icon: isSending ? null : Icons.send_rounded,
                  loadingWhenNull: true,
                  onTap: isSending ? null : _sendText,
                  color: _primaryColor,
                  filled: true,
                ),
              ],
            ),
          const SizedBox(height: 4),
          const Text(
            'AI có thể nhầm. Hãy kiểm tra lại đáp án quan trọng.',
            style: TextStyle(color: _textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }

  // ── Typing indicator ──────────────────────────────────────────────────

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _AiAvatar(),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _cardColor,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: _borderColor),
            ),
            child: _TypingIndicator(),
          ),
        ],
      ),
    );
  }

  // ── Sheets & Modals ───────────────────────────────────────────────────

  void _showNewConversationSheet(BuildContext context, AiState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<AiCubit>(),
        child: _NewConversationSheet(),
      ),
    );
  }

  void _showPaywallSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _cardColor,
      isScrollControlled: true,
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
        backgroundColor: Colors.red.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── Message Bubble Widget ────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final AiMessage message;
  const _MessageBubble({required this.message});

  static const _primaryColor = Color(0xFF6366F1);
  static const _cardColor = Color(0xFF1A1F2E);
  static const _borderColor = Color(0xFF2D3748);
  static const _textMuted = Color(0xFF64748B);

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == AiMessageRole.user;
    final timeStr = DateFormat('HH:mm').format(message.createdAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[_AiAvatar(), const SizedBox(width: 8)],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF7C3AED)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser ? null : _cardColor,
                border: isUser ? null : Border.all(color: _borderColor),
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
                  SelectableText(
                    message.content,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      timeStr,
                      style: TextStyle(
                        color: isUser
                            ? Colors.white.withOpacity(0.5)
                            : _textMuted,
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

// ── AI Avatar Widget ─────────────────────────────────────────────────────

class _AiAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28, height: 28,
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

// ── Typing Indicator Widget ──────────────────────────────────────────────

class _TypingIndicator extends StatefulWidget {
  @override
  _TypingIndicatorState createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        3,
        (i) => AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            final offset = ((_controller.value * 3) - i).clamp(0.0, 1.0);
            final bounce = offset < 0.5 ? offset * 2 : (1 - offset) * 2;
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 7, height: 7,
              transform: Matrix4.translationValues(0, -bounce * 6, 0),
              decoration: const BoxDecoration(
                color: Color(0xFF6366F1),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ── Suggestion Chip ──────────────────────────────────────────────────────

class _SuggestionChip extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _SuggestionChip({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1F2E),
          border: Border.all(color: const Color(0xFF2D3748)),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_right,
                color: Color(0xFF6366F1), size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(text,
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13)),
            ),
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
        width: 42, height: 42,
        decoration: BoxDecoration(
          color: filled ? color : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: icon == null && loadingWhenNull
            ? const SizedBox(
                width: 20, height: 20,
                child: Center(
                  child: SizedBox(
                    width: 16, height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  ),
                ),
              )
            : Icon(icon,
                color: filled ? Colors.white : color, size: 20),
      ),
    );
  }
}

// ── New Conversation Sheet ───────────────────────────────────────────────

class _NewConversationSheet extends StatelessWidget {
  final List<String> subjects = [
    'Toán', 'Văn', 'Anh', 'Lý', 'Hóa', 'Sinh', 'Sử', 'Địa', 'Khác'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cuộc trò chuyện mới',
              style: TextStyle(
                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('Chọn môn học (tuỳ chọn)',
              style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: subjects.map((s) => GestureDetector(
              onTap: () {
                context
                    .read<AiCubit>()
                    .createConversation(subject: s == 'Khác' ? null : s);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1F2E),
                  border: Border.all(color: const Color(0xFF2D3748)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(s,
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ),
            )).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                context.read<AiCubit>().createConversation();
                Navigator.pop(context);
              },
              child: const Text('Bỏ qua, tạo ngay',
                  style: TextStyle(color: Color(0xFF6366F1))),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF2D3748),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          const Icon(Icons.workspace_premium,
              color: Color(0xFFF59E0B), size: 48),
          const SizedBox(height: 16),
          const Text('Nâng cấp AI Premium',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          const Text(
            'Giải bài 24/7, không giới hạn tin nhắn\nhỗ trợ chụp ảnh bài tập Camera AI',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF64748B), fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              const Text('200.000đ',
                  style: TextStyle(
                      color: Color(0xFFF59E0B),
                      fontSize: 32,
                      fontWeight: FontWeight.w900)),
              const Text(' / tháng',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 14)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF161B27),
              border: Border.all(color: const Color(0xFF2D3748)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Text('📞', style: TextStyle(fontSize: 16)),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Liên hệ admin hoặc nhắn tin trong ứng dụng để kích hoạt',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
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
                backgroundColor: const Color(0xFF4F46E5),
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
