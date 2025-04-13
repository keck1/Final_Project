import 'dart:io';


import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/habit.dart';


class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  NotificationService() {
    _init();
  }

  Future<void> _init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    const channel = AndroidNotificationChannel(
      'habit_channel',
      'Habit Reminders',
      description: 'Notifications for your habit reminders',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  Future<void> requestPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.request();
      print("🔔 Notification permission granted? ${status.isGranted}");
    }
  }


  void showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'habit_channel',
      'Habit Reminders',
      channelDescription: 'Notifications for your habit reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(0, title, body, platformDetails);
  }

  void scheduleNotification(Habit habit) async {
    final scheduledTime = tz.TZDateTime.from(habit.dateTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'habit_channel',
      'Habit Reminders',
      channelDescription: 'Notifications for your habit reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const platformDetails = NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      habit.dateTime.millisecondsSinceEpoch ~/ 1000,
      'Habit Reminder',
      'Time for: ${habit.name}',
      scheduledTime,
      platformDetails,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation
          .absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
  void cancelNotification(int id) async {
    await _plugin.cancel(id);
  }
}

