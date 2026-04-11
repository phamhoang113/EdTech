import 'package:flutter/material.dart';

import '../../data/datasources/notification_datasource.dart';
import '../../data/models/notification_model.dart';
import '../../../../core/services/push_notification_service.dart';

/// Full notification list screen with lazy-load pagination.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _dataSource = NotificationDataSource();
  final _scrollController = ScrollController();

  final List<NotificationModel> _notifications = [];
  bool _loading = true;
  bool _loadingMore = false;
  bool _isLastPage = false;
  int _currentPage = 0;

  static const int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitial();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ═══════════════════════════════════════════════════
  // DATA
  // ═══════════════════════════════════════════════════

  Future<void> _loadInitial() async {
    try {
      final result = await _dataSource.getNotifications(page: 0, size: _pageSize);
      if (!mounted) return;
      setState(() {
        _notifications.clear();
        _notifications.addAll(result.content);
        _currentPage = 0;
        _isLastPage = result.isLast;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _loadMore() async {
    if (_loadingMore || _isLastPage) return;
    setState(() => _loadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final result = await _dataSource.getNotifications(page: nextPage, size: _pageSize);
      if (!mounted) return;
      setState(() {
        _notifications.addAll(result.content);
        _currentPage = nextPage;
        _isLastPage = result.isLast;
        _loadingMore = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  Future<void> _markAsRead(int index) async {
    final notif = _notifications[index];
    if (notif.isRead) return;

    try {
      await _dataSource.markAsRead(notif.id);
      if (!mounted) return;
      setState(() {
        _notifications[index] = notif.copyWith(isRead: true, readAt: DateTime.now());
      });
    } catch (_) {}
  }

  Future<void> _markAllRead() async {
    try {
      await _dataSource.markAllAsRead();
      if (!mounted) return;
      setState(() {
        for (int i = 0; i < _notifications.length; i++) {
          if (!_notifications[i].isRead) {
            _notifications[i] = _notifications[i].copyWith(isRead: true, readAt: DateTime.now());
          }
        }
      });
      _showSnack('Đã đánh dấu tất cả đã đọc ✅');
    } catch (_) {
      _showSnack('Lỗi', isError: true);
    }
  }

  void _onNotificationTap(int index) {
    _markAsRead(index);
    final notif = _notifications[index];
    final entityType = notif.entityType;
    if (entityType != null && entityType.isNotEmpty) {
      PushNotificationService.instance.onNotificationTap?.call(entityType, notif.entityId);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w500)),
      backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ));
  }

  // ═══════════════════════════════════════════════════
  // BUILD
  // ═══════════════════════════════════════════════════

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Thông báo'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface,
        ),
        actions: [
          if (_notifications.any((n) => !n.isRead))
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Đọc tất cả',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
              ),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
              ? _buildEmptyState(theme)
              : RefreshIndicator(
                  onRefresh: _loadInitial,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _notifications.length + (_loadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _notifications.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        );
                      }

                      // ── Date group header (Mockup 09) ──
                      final showHeader = index == 0 ||
                          !_isSameDay(_notifications[index].createdAt, _notifications[index - 1].createdAt);

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (showHeader)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                              child: Text(
                                _getDateLabel(_notifications[index].createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.onSurfaceVariant.withAlpha(150),
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          _buildNotificationItem(theme, index),
                        ],
                      );
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
          const SizedBox(height: 16),
          Text(
            'Chưa có thông báo nào',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn sẽ nhận thông báo khi có cập nhật mới',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant.withAlpha(150)),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(ThemeData theme, int index) {
    final notif = _notifications[index];
    final iconData = _getIconForType(notif.type);
    final iconColor = _getColorForType(notif.type);
    final timeAgo = _formatTimeAgo(notif.createdAt);

    return InkWell(
      onTap: () => _onNotificationTap(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: notif.isRead
              ? theme.colorScheme.surface
              : theme.colorScheme.primary.withAlpha(8),
          border: Border(
            bottom: BorderSide(color: theme.colorScheme.outline.withAlpha(20)),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withAlpha(20),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(iconData, size: 20, color: iconColor),
            ),
            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.body,
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant.withAlpha(120),
                    ),
                  ),
                ],
              ),
            ),

            // Unread dot
            if (!notif.isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════
  // HELPERS
  // ═══════════════════════════════════════════════════

  IconData _getIconForType(String type) {
    switch (type) {
      case 'CLASS_OPENED':
      case 'CLASS_CANCELLED':
      case 'CLASS_SUSPENDED':
      case 'CLASS_RESUMED':
      case 'CLASS_SUSPEND_REMINDER':
        return Icons.menu_book_outlined;
      case 'APPLICATION_RECEIVED':
      case 'APPLICATION_ACCEPTED':
      case 'APPLICATION_REJECTED':
        return Icons.people_outline;
      case 'INVOICE_RECEIPT_UPLOADED':
      case 'INVOICE_APPROVED':
      case 'INVOICE_REJECTED':
      case 'PAYOUT_TRANSFERRED':
        return Icons.credit_card_outlined;
      case 'SESSION_REMINDER':
      case 'MEET_LINK_SET':
      case 'SCHEDULE_UPDATED':
      case 'SCHEDULE_CONFIRMED':
        return Icons.calendar_today_outlined;
      case 'ABSENCE_REQUESTED':
      case 'ABSENCE_APPROVED':
      case 'ABSENCE_REJECTED':
        return Icons.event_busy_outlined;
      case 'NEW_MESSAGE':
        return Icons.chat_bubble_outline;
      case 'ASSESSMENT_PUBLISHED':
      case 'SUBMISSION_GRADED':
        return Icons.assignment_outlined;
      case 'CONTACT_MESSAGE_RECEIVED':
        return Icons.mail_outline;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'CLASS_OPENED':
      case 'CLASS_RESUMED':
        return const Color(0xFF3B82F6); // blue
      case 'CLASS_CANCELLED':
      case 'CLASS_SUSPENDED':
      case 'CLASS_SUSPEND_REMINDER':
        return const Color(0xFFEF4444); // red
      case 'APPLICATION_RECEIVED':
      case 'APPLICATION_ACCEPTED':
      case 'APPLICATION_REJECTED':
        return const Color(0xFF8B5CF6); // violet
      case 'INVOICE_RECEIPT_UPLOADED':
      case 'INVOICE_APPROVED':
      case 'PAYOUT_TRANSFERRED':
        return const Color(0xFF10B981); // green
      case 'INVOICE_REJECTED':
        return const Color(0xFFEF4444); // red
      case 'SESSION_REMINDER':
      case 'MEET_LINK_SET':
      case 'SCHEDULE_UPDATED':
      case 'SCHEDULE_CONFIRMED':
        return const Color(0xFFF59E0B); // orange
      case 'ABSENCE_REQUESTED':
      case 'ABSENCE_APPROVED':
      case 'ABSENCE_REJECTED':
        return const Color(0xFFEF4444); // red
      case 'NEW_MESSAGE':
        return const Color(0xFF6366F1); // indigo
      default:
        return const Color(0xFF6B7280); // gray
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return '${diff.inHours} giờ trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} tuần trước';
    return '${(diff.inDays / 30).floor()} tháng trước';
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _getDateLabel(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = today.difference(target).inDays;

    if (diff == 0) return 'HÔM NAY';
    if (diff == 1) return 'HÔM QUA';
    if (diff < 7) return '${diff} NGÀY TRƯỚC';
    return '${date.day}/${date.month}/${date.year}';
  }
}
