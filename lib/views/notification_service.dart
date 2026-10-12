import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workforceclientapp/Others/NotificationNavigationService.dart';

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
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification tapped! Payload: ${response.data.toString()}");
        if (response.payload != null && response.payload!.isNotEmpty) {
          try {
            final Map<String, dynamic> data = jsonDecode(response.payload!);
            NotificationNavigationService.handleNotificationTap(data);
          } catch (e) {
            print("Error decoding notification payload: $e");
          }
        }
      },
    );
  }

  static Future<void> showNotification(
    String title,
    String body, {
    Map<String, dynamic>? data,
  }) async {
    NotificationDetails details = const NotificationDetails(
      android: AndroidNotificationDetails('fcm_channel', 'FCM Notifications',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher'),
    );

    await _notifications.show(
      id: 0,
      title: title,
      body: body,
      notificationDetails: details,
      payload: data != null ? jsonEncode(data) : null,
    );
  }
}
