import 'package:sqflite/sqflite.dart';

class CalculateStats {

  Future<double> calculateCompleteRate(Database db, int habitId) async {
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final completedCount = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM habit_completions '
          'WHERE habit_id = ? AND completion_date >= ? AND completion_date <= ?',
      [
        habitId,
        sevenDaysAgo.toIso8601String(),
        now.toIso8601String(),
      ],
    ));
    if (completedCount == null) return 0.0;

    final expectedCount = 7;

    return completedCount / expectedCount;
  }

  Future<int> calculateStreak(Database db, int habitId) async {
    final now = DateTime.now();
    int streak = 0;
    DateTime currentDate = DateTime(now.year, now.month, now.day);

    final List<Map<String, dynamic>> completions = await db.rawQuery(
      'SELECT completion_date FROM habit_completions WHERE habit_id = ? ORDER BY completion_date DESC',
      [habitId],
    );
    if (completions.isEmpty) return 0;
    
    for (var completion in completions) {
      DateTime completionDate = DateTime.parse(completion['completion_date']);
      completionDate = DateTime(completionDate.year, completionDate.month, completionDate.day);
      
      if (completionDate == currentDate || completionDate == currentDate.subtract(Duration(days: 1))) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}