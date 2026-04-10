import '../../../../core/di/injection.dart';
import '../../../../core/network/dio_client.dart';
import '../models/notification_model.dart';

/// Data source for notification REST API calls.
class NotificationDataSource {
  final _dio = getIt<DioClient>().dio;

  /// Fetch paginated notifications for current user.
  Future<PaginatedNotifications> getNotifications({int page = 0, int size = 20}) async {
    final response = await _dio.get('/api/v1/notifications', queryParameters: {
      'page': page,
      'size': size,
    });
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return PaginatedNotifications.fromJson(data);
  }

  /// Get unread notification count.
  Future<int> getUnreadCount() async {
    final response = await _dio.get('/api/v1/notifications/unread-count');
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    return (data['count'] as num?)?.toInt() ?? 0;
  }

  /// Mark a single notification as read.
  Future<void> markAsRead(String notificationId) async {
    await _dio.patch('/api/v1/notifications/$notificationId/read');
  }

  /// Mark all notifications as read.
  Future<void> markAllAsRead() async {
    await _dio.patch('/api/v1/notifications/read-all');
  }

  /// Register FCM push token with backend.
  Future<void> registerPushToken(String token, {String deviceType = 'ANDROID'}) async {
    await _dio.post('/api/v1/push/register', data: {
      'token': token,
      'deviceType': deviceType,
    });
  }

  /// Unregister FCM push token (on logout).
  Future<void> unregisterPushToken(String token) async {
    await _dio.delete('/api/v1/push/unregister', queryParameters: {
      'token': token,
    });
  }
}
