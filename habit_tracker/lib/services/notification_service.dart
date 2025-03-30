import 'dart:async';
import 'dart:js_util' as js_util;
import 'dart:html' as html;
import 'package:habit_tracker/services/local_storage.dart';

import '../models/habit.dart';

class NotificationService {
  Future<void> requestPermission() async {
    final notificationConstructor = js_util.getProperty(html.window, 'Notification');
    if (js_util.getProperty(notificationConstructor, 'permission') != 'granted') {
      final permission = await js_util.promiseToFuture(
        js_util.callMethod(notificationConstructor, 'requestPermission', []),
      );
      print('Notification permission: $permission');
    }
  }

  void showNotification(String title, String body) {
    final notificationConstructor = js_util.getProperty(html.window, 'Notification');
    if (js_util.getProperty(notificationConstructor, 'permission') == 'granted') {
      js_util.callConstructor(
        notificationConstructor,
        [
          title,
          {'body': body}
        ],
      );
    } else {
      print('Notifications permission is not granted.');
    }
  }

  void scheduleNotification(Habit habit) {
    DateTime now = DateTime.now();
    DateTime scheduledTime = habit.dateTime;

    Duration delay = scheduledTime.difference(now);
    if (delay.isNegative) {
      scheduledTime = getNextScheduledTime(habit.dateTime, habit.frequency);
      delay = scheduledTime.difference(now);
    }

    Future.delayed(delay, () {
      if (!habit.completed) {
        showNotification('Habit Reminder', 'Time for: ${habit.name}');
      }

      if (habit.notificationsPerPeriod > 1 && !habit.completed) {
        scheduleAdditionalNotifications(habit);
      }

      scheduleNextNotification(habit);
    });
  }

  void scheduleAdditionalNotifications(Habit habit) {
    for (int i = 1; i < habit.notificationsPerPeriod; i++) {
      Duration additionalDelay = Duration(minutes: habit.notificationInterval * i);
      DateTime notificationTime = habit.dateTime.add(additionalDelay);
      DateTime now = DateTime.now();
      Duration delay = notificationTime.difference(now);

      if (delay.isNegative) {
        continue; 
      }

      Future.delayed(delay, () {
        if (!habit.completed) {
          showNotification('Habit Reminder', 'Time for: ${habit.name}');
        }
      });
    }
  }

  void scheduleNextNotification(Habit habit) {
    DateTime nextScheduledTime = getNextScheduledTime(habit.dateTime, habit.frequency);
    Habit nextHabit = Habit(
      name: habit.name,
      dateTime: nextScheduledTime,
      completed: false, 
      frequency: habit.frequency,
      notificationsPerPeriod: habit.notificationsPerPeriod,
      notificationInterval: habit.notificationInterval,
    );

      LocalStorage.saveHabits([nextHabit]); 

    scheduleNotification(nextHabit);
  }

  DateTime getNextScheduledTime(DateTime dateTime, Frequency frequency) {
    DateTime nextScheduledTime = dateTime;
    switch (frequency) {
      case Frequency.daily:
        nextScheduledTime = dateTime.add(const Duration(days: 1));
        break;
      case Frequency.weekly:
        nextScheduledTime = dateTime.add(const Duration(days: 7));
        break;
      case Frequency.monthly:
        nextScheduledTime = DateTime(dateTime.year, dateTime.month + 1, dateTime.day, dateTime.hour, dateTime.minute);
        break;
      case Frequency.custom:
        //TODO: Implement custom frequency logic
        // For now, just schedule for the next two days
        nextScheduledTime = dateTime.add(const Duration(days: 2));
        break;
    }
    return nextScheduledTime;
  }
}