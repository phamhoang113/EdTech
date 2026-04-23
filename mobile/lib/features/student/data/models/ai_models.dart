import 'dart:typed_data';

/// Data models cho module AI Study Companion.

// ── Subscription ──────────────────────────────────────────────────────────

enum AiSubscriptionStatusEnum { trial, active, expired, cancelled }

class AiSubscriptionStatus {
  final String subscriptionId;
  final AiSubscriptionStatusEnum status;
  final int? trialDaysRemaining;
  final DateTime? paidUntil;
  final bool canUseAi;
  final bool isTrial; // map từ JSON field 'trial'

  const AiSubscriptionStatus({
    required this.subscriptionId,
    required this.status,
    this.trialDaysRemaining,
    this.paidUntil,
    required this.canUseAi,
    required this.isTrial,
  });

  factory AiSubscriptionStatus.fromJson(Map<String, dynamic> json) {
    final statusStr = (json['status'] as String).toUpperCase();
    final status = switch (statusStr) {
      'TRIAL' => AiSubscriptionStatusEnum.trial,
      'ACTIVE' => AiSubscriptionStatusEnum.active,
      'EXPIRED' => AiSubscriptionStatusEnum.expired,
      _ => AiSubscriptionStatusEnum.cancelled,
    };

    return AiSubscriptionStatus(
      subscriptionId: json['subscriptionId'] as String,
      status: status,
      trialDaysRemaining: json['trialDaysRemaining'] as int?,
      paidUntil: json['paidUntil'] != null
          ? DateTime.parse(json['paidUntil'] as String)
          : null,
      canUseAi: (json['canUseAi'] as bool?) ?? false,
      // Backend Java serialize 'private boolean isTrial' thành key 'trial'
      isTrial: (json['trial'] as bool?) ?? (json['isTrial'] as bool?) ?? false,
    );
  }
}

// ── Conversation ──────────────────────────────────────────────────────────

class AiConversation {
  final String id;
  final String title;
  final String? subject;
  final String? grade;
  final String? learningGoal;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AiConversation({
    required this.id,
    required this.title,
    this.subject,
    this.grade,
    this.learningGoal,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AiConversation.fromJson(Map<String, dynamic> json) {
    return AiConversation(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'Cuộc trò chuyện',
      subject: json['subject'] as String?,
      grade: json['grade'] as String?,
      learningGoal: json['learningGoal'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  AiConversation copyWith({String? learningGoal}) {
    return AiConversation(
      id: id,
      title: title,
      subject: subject,
      grade: grade,
      learningGoal: learningGoal ?? this.learningGoal,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// ── Message ───────────────────────────────────────────────────────────────

enum AiMessageRole { user, assistant }

class AiMessage {
  final String id;
  final AiMessageRole role;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  const AiMessage({
    required this.id,
    required this.role,
    required this.content,
    this.imageUrl,
    required this.createdAt,
  });

  factory AiMessage.fromJson(Map<String, dynamic> json) {
    return AiMessage(
      id: json['id'] as String,
      role: (json['role'] as String).toUpperCase() == 'USER'
          ? AiMessageRole.user
          : AiMessageRole.assistant,
      content: json['content'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Message tạm thời khi đang gửi (chưa có ID thật)
  factory AiMessage.optimistic({
    required String content,
    Uint8List? imageBytes,
  }) {
    return AiMessage(
      id: 'temp_${DateTime.now().millisecondsSinceEpoch}',
      role: AiMessageRole.user,
      content: content,
      imageUrl: null,
      createdAt: DateTime.now(),
    );
  }
}
