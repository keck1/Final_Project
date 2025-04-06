import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';
import 'add_habit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      appBar: AppBar(
        title: const Text('Your Habits'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
              child: _habits.isEmpty
                  ? const Center(child: Text("There are no habits to display. Tap '+' to add a new one."))
                  : ListView.builder(
                itemCount: _habits.length,
                itemBuilder: (context, index) {
                  final habit = _habits[index];
                  return Dismissible(
                    key: Key(_habits[index].name),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      _deleteHabit(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${habit.name} deleted')),
                      );
                    },
                    background: Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Icon(
                          habit.completed ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: habit.completed ? Colors.green : Colors.grey,
                          size: 28,
                        ),
                        title: Text(
                          habit.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            decoration: habit.completed ? TextDecoration.lineThrough : null,
                            color: habit.completed ? Colors.grey : null,
                          ),
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.notifications_active, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              'Reminder: ${habit.dateTime.hour}:${habit.dateTime.minute.toString().padLeft(2, '0')}',
                            ),
                          ],
                        ),
                        trailing: Checkbox(
                          value: habit.completed,
                          onChanged: (_) => _toggleCompletion(index),
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: () {
                _notificationService.showNotification('Test', 'This is a test notification');
              },
              icon: const Icon(Icons.notification_add),
              label: const Text('Test Notification'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddHabit,
        icon: const Icon(Icons.add),
        label: const Text("Add Habit"),
      ),
    );
  }
}