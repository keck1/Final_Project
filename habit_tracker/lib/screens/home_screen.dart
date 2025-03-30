import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadHabits();
    _notificationService.requestPermission();
  }

  Future<void> _loadHabits() async {
    final habits = await LocalStorage.loadHabits();
    setState(() {
      _habits = habits;
    });
  }

  void _toggleCompletion(int index) async {
    setState(() {
      _habits[index].completed = !_habits[index].completed;
    });
    await LocalStorage.saveHabits(_habits);
  }

  void _navigateToAddHabit() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddHabitScreen()),
    );
    _loadHabits(); 
  }

  void _deleteHabit(int index) async {
    setState(() {
      _habits.removeAt(index);
    });
    await LocalStorage.saveHabits(_habits);
    _loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Habits')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(_habits[index].name),
                  onDismissed: (direction) {
                    _deleteHabit(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${_habits[index].name} deleted')));
                  },
                  background: Container(color: Colors.red),
                  child: ListTile(
                    title: Text(_habits[index].name),
                    subtitle: Text('Reminder: ${_habits[index].dateTime.toString()}'),
                    trailing: Checkbox(
                      value: _habits[index].completed,
                      onChanged: (_) => _toggleCompletion(index),
                    ),
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _notificationService.showNotification('Test', 'This is a test notification');
            },
            child: const Text('Test Notification'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: _navigateToAddHabit,
      ),
    );
  }
}