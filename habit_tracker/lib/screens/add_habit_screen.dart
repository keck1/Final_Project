import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../services/local_storage.dart';
import '../services/notification_service.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  State<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  Frequency _selectedFrequency = Frequency.daily;
  int _notificationsPerPeriod = 1;
  int _notificationInterval = 0;
  final NotificationService _notificationService = NotificationService();

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _saveHabit() async {
    if (_habitController.text.isEmpty) return;

    DateTime selectedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final newHabit = Habit(
      name: _habitController.text,
      dateTime: selectedDateTime,
      frequency: _selectedFrequency,
      notificationsPerPeriod: _notificationsPerPeriod,
      notificationInterval: _notificationInterval,
    );

    final habits = await LocalStorage.loadHabits();
    habits.add(newHabit);
    await LocalStorage.saveHabits(habits);

    _notificationService.scheduleNotification(newHabit);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Habit')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard on tap
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              TextField(
                controller: _habitController,
                decoration: InputDecoration(
                  labelText: 'Habit Name',
                  border: OutlineInputBorder(),
                  errorText: _habitController.text.isEmpty ? 'Please enter a name' : null,
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickDate(context),
                      icon: const Icon(Icons.calendar_today),
                      label: Text('Date: ${_selectedDate.toString().split(' ')[0]}'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _pickTime(context),
                      icon: const Icon(Icons.access_time),
                      label: Text('Time: ${_selectedTime.format(context)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<Frequency>(
                decoration: const InputDecoration(
                  labelText: 'Frequency',
                  border: OutlineInputBorder(),
                ),
                value: _selectedFrequency,
                onChanged: (Frequency? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedFrequency = newValue;
                    });
                  }
                },
                items: Frequency.values.map((Frequency frequency) {
                  return DropdownMenuItem<Frequency>(
                    value: frequency,
                    child: Text(frequency.toString().split('.').last),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Reminders per Period',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _notificationsPerPeriod.toString(),
                onChanged: (value) {
                  setState(() {
                    _notificationsPerPeriod = int.tryParse(value) ?? 1;
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Remind Every (minutes)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                initialValue: _notificationInterval.toString(),
                onChanged: (value) {
                  setState(() {
                    _notificationInterval = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: _saveHabit,
                icon: const Icon(Icons.check),
                label: const Text('Save Habit'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}