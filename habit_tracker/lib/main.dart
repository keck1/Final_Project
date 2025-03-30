import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  
  runApp(const HabitApp());
}

class HabitApp extends StatelessWidget {
  const HabitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}
