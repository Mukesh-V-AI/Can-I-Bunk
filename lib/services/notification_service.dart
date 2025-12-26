import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'dart:io' show Platform;
import '../models/class_session.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return; // Skip on web or unsupported platforms

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings settings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> scheduleClassReminder(ClassSession session) async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return; // Skip on web or unsupported platforms

    final reminderTime = session.startTime.subtract(const Duration(minutes: 10));
    if (reminderTime.isBefore(DateTime.now())) return; // Don't schedule past reminders

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'class_reminder',
      'Class Reminders',
      channelDescription: 'Reminders for upcoming classes',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      session.id.hashCode,
      'Class Reminder',
      'Your ${session.subjectName} class starts in 10 minutes.',
      tz.TZDateTime.from(reminderTime, tz.local),
      details,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> showGuidanceNotification(String title, String body) async {
    if (kIsWeb || !Platform.isAndroid && !Platform.isIOS) return; // Skip on web or unsupported platforms

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'guidance',
      'Attendance Guidance',
      channelDescription: 'Guidance on attendance decisions',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title,
      body,
      details,
    );
  }
}
