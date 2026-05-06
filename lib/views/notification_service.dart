import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  static Function(Map<String, dynamic>)? onNotificationTap;

  static Future<void> init(Function(Map<String, dynamic>) onTap) async {
    onNotificationTap = onTap;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();

    const settings = InitializationSettings(android: android, iOS: ios);

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        if (response.payload != null) {
          final data = jsonDecode(response.payload!);
          onNotificationTap?.call(data);
          // _handleNotificationNavigation(data);
        }
      },
    );
  }

  static Future<void> showNotification(String title, String body) async {
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails(
          'fcm_channel',
          'FCM Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ));
    await _notifications.show(
        id: 0, title: title, body: body, notificationDetails: details);
  }
}
