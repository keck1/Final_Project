//handles local storage
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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

  Future<Database> initializeDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'habit_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE habit_completions ('
          'id INTEGER PRIMARY KEY,'
          'habit if INTEGER, ' // FK
          'completion_date TEXT, '
          'FOREIGN KEY (habit_id) REFERENCES habits(id)'
          ')',
        );
      }
    );
  }

  Future<void> recordCompletion(Database db, int habitId) async {
    await db.insert(
        'habit_completions',
        {
          'habit_id': habitId,
          'completion_date': DateTime.now().toIso8601String(),
        },
    );
  }
}
