// habit model
enum Frequency { daily, weekly, monthly, custom }

class Habit {
  String name;
  DateTime dateTime;
  bool completed;
  Frequency frequency;
  int notificationsPerPeriod;
  int notificationInterval;
  DateTime? lastCompleted; // Nullable DateTime

  Habit({
    required this.name,
    required this.dateTime,
    this.completed = false,
    this.frequency = Frequency.daily,
    this.notificationsPerPeriod = 1,
    this.notificationInterval = 0,
    this.lastCompleted,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'dateTime': dateTime.toIso8601String(),
    'completed': completed,
    'frequency': frequency.toString(),
    'notificationsPerPeriod': notificationsPerPeriod,
    'notificationInterval': notificationInterval,
    'lastCompleted': lastCompleted?.toIso8601String(), 
  };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
    name: json['name'],
    dateTime: DateTime.parse(json['dateTime']),
    completed: json['completed'] ?? false,
    frequency: Frequency.values.firstWhere((e) => e.toString() == json['frequency'], orElse: () => Frequency.daily),
    notificationsPerPeriod: json['notificationsPerPeriod'] ?? 1,
    notificationInterval: json['notificationInterval'] ?? 0,
    lastCompleted: json['lastCompleted'] != null ? DateTime.parse(json['lastCompleted']) : null,
  );
  Habit copyWith({
    String? name,
    DateTime? dateTime,
    bool? completed,
    Frequency? frequency,
    int? notificationsPerPeriod,
    int? notificationInterval,
    DateTime? lastCompleted,
  }) {
    return Habit(
      name: name ?? this.name,
      dateTime: dateTime ?? this.dateTime,
      completed: completed ?? this.completed,
      frequency: frequency ?? this.frequency,
      notificationsPerPeriod: notificationsPerPeriod ?? this.notificationsPerPeriod,
      notificationInterval: notificationInterval ?? this.notificationInterval,
      lastCompleted: lastCompleted ?? this.lastCompleted,
    );
  }
}