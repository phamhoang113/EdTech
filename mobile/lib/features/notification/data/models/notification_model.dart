/// Model for notification data from backend API.
class NotificationModel {
  final String id;
  final String type;
  final String title;
  final String body;
  final String? entityType;
  final String? entityId;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.entityType,
    this.entityId,
    required this.isRead,
    this.readAt,
    required this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      entityType: json['entityType']?.toString(),
      entityId: json['entityId']?.toString(),
      isRead: json['isRead'] == true || json['read'] == true,
      readAt: json['readAt'] != null ? DateTime.tryParse(json['readAt'].toString()) : null,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  NotificationModel copyWith({bool? isRead, DateTime? readAt}) {
    return NotificationModel(
      id: id,
      type: type,
      title: title,
      body: body,
      entityType: entityType,
      entityId: entityId,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
      createdAt: createdAt,
    );
  }
}

/// Paginated response wrapper for notifications.
class PaginatedNotifications {
  final List<NotificationModel> content;
  final int totalElements;
  final int totalPages;
  final int currentPage;
  final bool isLast;

  const PaginatedNotifications({
    required this.content,
    required this.totalElements,
    required this.totalPages,
    required this.currentPage,
    required this.isLast,
  });

  factory PaginatedNotifications.fromJson(Map<String, dynamic> json) {
    final contentList = (json['content'] as List<dynamic>? ?? [])
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return PaginatedNotifications(
      content: contentList,
      totalElements: (json['totalElements'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 0,
      currentPage: (json['number'] as num?)?.toInt() ?? 0,
      isLast: json['last'] == true,
    );
  }
}
