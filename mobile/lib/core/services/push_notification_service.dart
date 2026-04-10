import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../features/notification/data/datasources/notification_datasource.dart';

/// Top-level handler for background FCM messages (must be top-level function).
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('[FCM] Background message: ${message.notification?.title}');
}

/// Singleton service managing FCM push notification lifecycle.
///
/// Responsibilities:
/// 1. Initialize Firebase + local notifications
/// 2. Request permission + register FCM token with backend
/// 3. Handle foreground notifications (show local notification)
/// 4. Handle background/terminated notifications (OS handles display)
/// 5. Handle notification taps (navigation via callback)
/// 6. Unregister token on logout
class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  FirebaseMessaging? _messaging;
  FlutterLocalNotificationsPlugin? _localNotifications;
  final NotificationDataSource _dataSource = NotificationDataSource();

  String? _currentToken;
  void Function(String entityType, String? entityId)? onNotificationTap;
  void Function()? onNotificationReceived;

  /// Android notification channel
  static const _androidChannel = AndroidNotificationChannel(
    'edtech_notifications',
    'Thông báo EdTech',
    description: 'Thông báo từ nền tảng Gia Sư Tinh Hoa',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  /// Initialize Firebase and notification handlers.
  /// Call once at app startup (main.dart).
  /// Skips entirely on web — push notifications are Android/iOS only.
  Future<void> initialize() async {
    if (kIsWeb) {
      debugPrint('[FCM] Skipping FCM init on web platform');
      return;
    }

    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('[FCM] Firebase already initialized or error: $e');
    }

    _messaging = FirebaseMessaging.instance;
    _localNotifications = FlutterLocalNotificationsPlugin();

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup local notification plugin for foreground display
    await _setupLocalNotifications();

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Listen for notification tap (app in background → user taps)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // Check if app was opened from terminated state via notification tap
    final initialMessage = await _messaging!.getInitialMessage();
    if (initialMessage != null) {
      // Delay to ensure navigation is ready
      Future.delayed(const Duration(seconds: 1), () {
        _handleNotificationTap(initialMessage);
      });
    }

    // Listen for token refresh
    _messaging!.onTokenRefresh.listen(_onTokenRefresh);
  }

  /// Request notification permission and register FCM token with backend.
  /// Call after successful login.
  Future<void> requestPermissionAndRegisterToken() async {
    if (kIsWeb || _messaging == null) return;
    try {
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        debugPrint('[FCM] Notification permission denied');
        return;
      }

      // Get FCM token
      final token = await _messaging!.getToken();
      if (token != null) {
        _currentToken = token;
        final deviceType = _detectDeviceType();
        await _dataSource.registerPushToken(token, deviceType: deviceType);
        debugPrint('[FCM] Token registered: ${token.substring(0, 20)}...');
      }
    } catch (e) {
      debugPrint('[FCM] Error requesting permission/registering token: $e');
    }
  }

  /// Unregister FCM token from backend. Call on logout.
  Future<void> unregisterToken() async {
    if (kIsWeb) return;
    try {
      if (_currentToken != null) {
        await _dataSource.unregisterPushToken(_currentToken!);
        debugPrint('[FCM] Token unregistered');
        _currentToken = null;
      }
    } catch (e) {
      debugPrint('[FCM] Error unregistering token: $e');
    }
  }

  // ═══════════════════════════════════════════════════
  // PRIVATE
  // ═══════════════════════════════════════════════════

  Future<void> _setupLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _localNotifications!.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        // User tapped local notification
        final payload = details.payload;
        if (payload != null) {
          final parts = payload.split('|');
          final entityType = parts.isNotEmpty ? parts[0] : '';
          final entityId = parts.length > 1 ? parts[1] : null;
          if (entityType.isNotEmpty) {
            onNotificationTap?.call(entityType, entityId);
          }
        }
      },
    );

    // Create notification channel for Android
    final androidPlugin = _localNotifications!.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(_androidChannel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('[FCM] Foreground message: ${message.notification?.title}');

    final notification = message.notification;
    if (notification == null) return;

    // Show local notification banner
    _localNotifications?.show(
      notification.hashCode,
      notification.title ?? 'Thông báo mới',
      notification.body ?? '',
      NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      // Encode entityType|entityId as payload for tap handling
      payload: '${message.data['entityType'] ?? ''}|${message.data['entityId'] ?? ''}',
    );

    // Notify listeners to refresh notification count
    onNotificationReceived?.call();
  }

  void _handleNotificationTap(RemoteMessage message) {
    final entityType = message.data['entityType']?.toString() ?? '';
    final entityId = message.data['entityId']?.toString();

    debugPrint('[FCM] Notification tapped: entityType=$entityType, entityId=$entityId');

    if (entityType.isNotEmpty) {
      onNotificationTap?.call(entityType, entityId);
    }
  }

  Future<void> _onTokenRefresh(String newToken) async {
    debugPrint('[FCM] Token refreshed');
    _currentToken = newToken;
    try {
      final deviceType = _detectDeviceType();
      await _dataSource.registerPushToken(newToken, deviceType: deviceType);
    } catch (e) {
      debugPrint('[FCM] Error re-registering refreshed token: $e');
    }
  }

  String _detectDeviceType() {
    if (kIsWeb) return 'WEB';
    if (Platform.isAndroid) return 'ANDROID';
    if (Platform.isIOS) return 'IOS';
    return 'UNKNOWN';
  }
}
