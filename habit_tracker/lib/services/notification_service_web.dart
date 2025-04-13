import 'dart:html' as html;
import 'dart:js_util' as js_util;

import '../models/habit.dart';

class NotificationService {
  Future<void> requestPermission() async {
    final permissionStatus = js_util.getProperty(
      js_util.getProperty(html.window, 'Notification'),
      'permission',
    ) as String;

    print("Current notification permission: $permissionStatus");

    if (permissionStatus == 'default') {
      print("Permission not granted yet — requesting it...");
      final permission = await js_util.promiseToFuture<String>(
        js_util.callMethod(
          js_util.getProperty(html.window, 'Notification'),
          'requestPermission',
          [],
        ),
      );
      print(" User selected: $permission");
    } else if (permissionStatus == 'denied') {
      print("Permission was previously denied. You may need to instruct the user to allow it via site settings.");
      //optionally display a custom popup or banner here telling them to enable notifications manually
    } else {
      print("Notifications already permitted!");
    }
  }

  void showNotification(String title, String body) {
    final notificationConstructor = js_util.getProperty(html.window, 'Notification');
    final permission = js_util.getProperty(notificationConstructor, 'permission');

    if (permission == 'granted') {
      js_util.callConstructor(
        notificationConstructor,
        [
          title,
          {'body': body}
        ],
      );
    } else {
      print("Notification blocked — permission not granted.");
    }
  }

  void scheduleNotification(Habit habit) {
    // keep it aggressive
    requestPermission().then((_) {
      final now = DateTime.now();
      final delay = habit.dateTime.difference(now);

      if (delay.isNegative) {
        showNotification("Habit Reminder", "Time for: ${habit.name}");
        return;
      }

      Future.delayed(delay, () {
        showNotification("Habit Reminder", "Time for: ${habit.name}");
      });
    });
  }
}
  DateTime _getNextScheduledTime(DateTime dt, Frequency f) {
    switch (f) {
      case Frequency.daily: return dt.add(const Duration(days: 1));
      case Frequency.weekly: return dt.add(const Duration(days: 7));
      case Frequency.monthly: return DateTime(dt.year, dt.month + 1, dt.day, dt.hour, dt.minute);
      case Frequency.custom: return dt.add(const Duration(days: 2));
    }
  }

