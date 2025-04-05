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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
        colorScheme: ColorScheme.dark(
          primary: Colors.tealAccent,
          secondary: Colors.teal,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
          elevation: 2,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.tealAccent,
          foregroundColor: Colors.black,
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.teal,
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16),
          bodyLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
