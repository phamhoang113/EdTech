import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/di/injection.dart';
import 'core/services/push_notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  configureDependencies();

  // Initialize Firebase + FCM push notification handlers
  await PushNotificationService.instance.initialize();
  
  runApp(const EdTechApp());
}
