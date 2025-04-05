//handles local storage
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/habit.dart';

class LocalStorage {
  static Future<void> saveHabits(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('habits', jsonEncode(habits.map((h) => h.toJson()).toList()));
  }

  static Future<List<Habit>> loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final String? habitsJson = prefs.getString('habits');
    if (habitsJson != null) {
      return (jsonDecode(habitsJson) as List).map((data) => Habit.fromJson(data)).toList();
    }
    return [];
  }
}
