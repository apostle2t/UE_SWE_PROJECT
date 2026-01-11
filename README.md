NutriTrack is a mobile meal-tracking application developed using Flutter.
The app allows users to log meals with a specific date and time, store them locally using SQLite, and view insightful statistics about their eating habits.
It is designed with a clean, modern UI and supports light and dark modes.

Features
-Log Meals
-Add meals with a name, date, and time
-Simple and intuitive logging interface
-Meal History
-View all logged meals grouped by date
-Search meals by name
-Edit or delete previously logged meals
-Statistics Dashboard
-Meals logged this week
-Meals logged this month
-Current day streak
-Total meals logged
-Bar chart showing meals over the last 7 days
-Local Data Storage
-Uses SQLite for persistent local storage
-Data remains available between app sessions
-Dark & Light Mode
-Help Screen
-Provides guidance on how to use the application

Technologies That Were Used
-Flutter (Dart) – UI development and application logic
-SQLite – Local database for meal storage
-Android Studio – Development and demonstration environment

Application Logic Overview
-Meals are stored locally using SQLite
-Each meal contains:
-Meal name
-Date
-Time
-Utility classes handle:
-Date/time formatting
-Statistical calculations

How to Run the App
-Open the project in Android Studio
-Ensure Flutter SDK is installed and configured
-Launch the app on an Android emulator or physical device
