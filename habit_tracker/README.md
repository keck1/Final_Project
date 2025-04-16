# Habit Tracker

A simple habit tracking application built with Flutter.

## Description

This application allows users to create and track their habits. It provides features for setting reminders, customizing notification schedules, and marking habits as complete. Currently is only a basic implementation. 

## Features

*   **Add Habits:** Users can add new habits with a name, date, and time.
*   **List Habits:** Displays a list of all created habits.
*   **Mark Completion:** Users can mark habits as complete.
*   **Delete Habits:** Users can delete habits from the list.
*   **Local Storage:** Habits are stored locally using `shared_preferences`, so they persist between app sessions.
*   **Notifications:**
    *   In-browser notifications to remind users of their habits.
    *   Customizable notification frequency (daily, weekly, monthly).
    *   Option to set multiple reminders per period.
    *   Customizable reminder intervals.
    *   Notifications stop for the current period once the habit is marked as complete.

## To-Do List

*   Improve UI/UX for better user experience.
*   Implement custom frequency logic for habits.
*   Implement data migration for older app versions.
*   Add error handling to notification scheduling.
*   Explore using service workers for more reliable background notifications.
*   Add statistics and progress tracking.

## Technologies Used

*   Flutter
*   Dart
*   `shared_preferences` package
*   `dart:js_util` and `dart:html` for in-browser notifications

## Project Structure

*   `lib/main.dart`:  The main entry point of the application.
*   `lib/screens/`: Contains the UI screens:
    *   `home_screen.dart`: Displays the list of habits and allows adding new habits.
    *   `add_habit_screen.dart`:  Allows users to create new habits.
*   `lib/models/`: Contains the data models:
    *   `habit.dart`: Defines the `Habit` class.
*   `lib/services/`: Contains services:
    *   `local_storage.dart`: Handles saving and loading habits from local storage.
    *   `notification_service.dart`: Handles scheduling and displaying notifications.

