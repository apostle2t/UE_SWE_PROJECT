# NutriTrack Local Storage Setup Guide

This document outlines the setup for offline local storage using SQLite in the NutriTrack Flutter application.

---

## Table of Contents

1. [Overview](#overview)
2. [Why SQLite](#why-sqlite)
3. [Required Packages](#required-packages)
4. [Database Schema](#database-schema)
5. [Project Structure](#project-structure)
6. [Implementation Guide](#implementation-guide)
7. [Database Helper Class](#database-helper-class)
8. [Updated Meal Model](#updated-meal-model)
9. [Meal Repository](#meal-repository)
10. [Connecting to UI](#connecting-to-ui)
11. [Data Export/Import (Optional)](#data-exportimport-optional)
12. [Setup Checklist](#setup-checklist)

---

## Overview

NutriTrack is an **offline-first** application that stores all meal data locally on the device using SQLite. 

**Features:**
- ✅ No internet required
- ✅ No account/authentication needed
- ✅ Fast local queries
- ✅ Data persists across app restarts
- ✅ Works on Android, iOS, macOS, Windows, Linux

---

## Why SQLite

| Feature | SQLite |
|---------|--------|
| **Type** | Relational SQL database |
| **Storage** | Local file on device |
| **Queries** | Full SQL support |
| **Performance** | Excellent for structured data |
| **Platform Support** | All Flutter platforms |
| **Complexity** | Medium |
| **Best For** | Structured data with relationships |

---

## Required Packages

Add these to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
    
  # SQLite Database
  sqflite: ^2.3.0
  
  # Path helper for database location
  path: ^1.8.3
  
  # For web support (optional)
  sqflite_common_ffi_web: ^0.4.3
  
  # Already in your project
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

Then run:
```bash
flutter pub get
```

---

## Database Schema

### Meals Table

```sql
CREATE TABLE meals (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  calories INTEGER,
  protein REAL,
  carbs REAL,
  fat REAL,
  meal_date TEXT NOT NULL,
  meal_time TEXT NOT NULL,
  meal_type TEXT,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL
);

-- Index for faster date queries
CREATE INDEX idx_meals_date ON meals(meal_date);
```

### Settings Table (Optional - for user preferences)

```sql
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);
```

---

## Project Structure

```
lib/
├── main.dart
├── models/
│   └── meal.dart              # Updated with toMap/fromMap
├── database/
│   └── database_helper.dart   # SQLite initialization & queries
├── repositories/
│   └── meal_repository.dart   # Data access layer
├── screens/
│   └── home_screen.dart
├── widgets/
│   ├── common/
│   └── tabs/
├── theme/
└── utils/
```

---

## Implementation Guide

### Step 1: Create Database Helper

Create `lib/database/database_helper.dart`:

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nutritrack.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Meals table
    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        calories INTEGER,
        protein REAL,
        carbs REAL,
        fat REAL,
        meal_date TEXT NOT NULL,
        meal_time TEXT NOT NULL,
        meal_type TEXT,
        notes TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Index for faster date queries
    await db.execute(
      'CREATE INDEX idx_meals_date ON meals(meal_date)'
    );

    // Settings table
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here for future versions
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE meals ADD COLUMN new_field TEXT');
    // }
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}
```

---

### Step 2: Update Meal Model

Update `lib/models/meal.dart`:

```dart
import 'package:flutter/material.dart';

class Meal {
  final String id;
  final String name;
  final int? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final DateTime date;
  final TimeOfDay time;
  final String? mealType;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Meal({
    required this.id,
    required this.name,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    required this.date,
    required this.time,
    this.mealType,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert Meal to Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'meal_date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'meal_time': '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
      'meal_type': mealType,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Create Meal from SQLite Map
  factory Meal.fromMap(Map<String, dynamic> map) {
    final timeParts = (map['meal_time'] as String).split(':');
    
    return Meal(
      id: map['id'] as String,
      name: map['name'] as String,
      calories: map['calories'] as int?,
      protein: map['protein'] as double?,
      carbs: map['carbs'] as double?,
      fat: map['fat'] as double?,
      date: DateTime.parse(map['meal_date'] as String),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      mealType: map['meal_type'] as String?,
      notes: map['notes'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Create a copy with updated fields
  Meal copyWith({
    String? id,
    String? name,
    int? calories,
    double? protein,
    double? carbs,
    double? fat,
    DateTime? date,
    TimeOfDay? time,
    String? mealType,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      date: date ?? this.date,
      time: time ?? this.time,
      mealType: mealType ?? this.mealType,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Generate a unique ID
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
```

---

### Step 3: Create Meal Repository

Create `lib/repositories/meal_repository.dart`:

```dart
import '../database/database_helper.dart';
import '../models/meal.dart';

class MealRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ============ CREATE ============
  
  /// Insert a new meal
  Future<void> insertMeal(Meal meal) async {
    final db = await _dbHelper.database;
    await db.insert('meals', meal.toMap());
  }

  // ============ READ ============
  
  /// Get all meals
  Future<List<Meal>> getAllMeals() async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'meals',
      orderBy: 'meal_date DESC, meal_time DESC',
    );
    return maps.map((map) => Meal.fromMap(map)).toList();
  }

  /// Get meals for a specific date
  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    
    final maps = await db.query(
      'meals',
      where: 'meal_date = ?',
      whereArgs: [dateStr],
      orderBy: 'meal_time ASC',
    );
    return maps.map((map) => Meal.fromMap(map)).toList();
  }

  /// Get meals for a date range
  Future<List<Meal>> getMealsByDateRange(DateTime start, DateTime end) async {
    final db = await _dbHelper.database;
    final startStr = start.toIso8601String().split('T')[0];
    final endStr = end.toIso8601String().split('T')[0];
    
    final maps = await db.query(
      'meals',
      where: 'meal_date >= ? AND meal_date <= ?',
      whereArgs: [startStr, endStr],
      orderBy: 'meal_date DESC, meal_time DESC',
    );
    return maps.map((map) => Meal.fromMap(map)).toList();
  }

  /// Get a single meal by ID
  Future<Meal?> getMealById(String id) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (maps.isEmpty) return null;
    return Meal.fromMap(maps.first);
  }

  /// Get meal count for statistics
  Future<int> getMealCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM meals');
    return result.first['count'] as int;
  }

  /// Get meals grouped by date (for history)
  Future<Map<String, List<Meal>>> getMealsGroupedByDate() async {
    final meals = await getAllMeals();
    final Map<String, List<Meal>> grouped = {};
    
    for (final meal in meals) {
      final dateKey = meal.date.toIso8601String().split('T')[0];
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(meal);
    }
    
    return grouped;
  }

  // ============ UPDATE ============
  
  /// Update an existing meal
  Future<void> updateMeal(Meal meal) async {
    final db = await _dbHelper.database;
    await db.update(
      'meals',
      meal.copyWith(updatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [meal.id],
    );
  }

  // ============ DELETE ============
  
  /// Delete a meal by ID
  Future<void> deleteMeal(String id) async {
    final db = await _dbHelper.database;
    await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all meals (use with caution!)
  Future<void> deleteAllMeals() async {
    final db = await _dbHelper.database;
    await db.delete('meals');
  }

  // ============ STATISTICS ============
  
  /// Get total calories for a date
  Future<int> getTotalCaloriesForDate(DateTime date) async {
    final db = await _dbHelper.database;
    final dateStr = date.toIso8601String().split('T')[0];
    
    final result = await db.rawQuery(
      'SELECT SUM(calories) as total FROM meals WHERE meal_date = ?',
      [dateStr],
    );
    
    return (result.first['total'] as int?) ?? 0;
  }

  /// Get daily statistics for last N days
  Future<List<Map<String, dynamic>>> getDailyStats(int days) async {
    final db = await _dbHelper.database;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    
    final result = await db.rawQuery('''
      SELECT 
        meal_date,
        COUNT(*) as meal_count,
        SUM(calories) as total_calories,
        SUM(protein) as total_protein,
        SUM(carbs) as total_carbs,
        SUM(fat) as total_fat
      FROM meals
      WHERE meal_date >= ? AND meal_date <= ?
      GROUP BY meal_date
      ORDER BY meal_date DESC
    ''', [
      startDate.toIso8601String().split('T')[0],
      endDate.toIso8601String().split('T')[0],
    ]);
    
    return result;
  }
}
```

---

## Connecting to UI

### Update HomeScreen to use Repository

```dart
// In your home_screen.dart or wherever you manage state

import '../repositories/meal_repository.dart';

class _HomeScreenState extends State<HomeScreen> {
  final MealRepository _mealRepository = MealRepository();
  List<Meal> _meals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() => _isLoading = true);
    final meals = await _mealRepository.getAllMeals();
    setState(() {
      _meals = meals;
      _isLoading = false;
    });
  }

  Future<void> _addMeal(Meal meal) async {
    await _mealRepository.insertMeal(meal);
    await _loadMeals(); // Refresh the list
  }

  Future<void> _updateMeal(Meal meal) async {
    await _mealRepository.updateMeal(meal);
    await _loadMeals();
  }

  Future<void> _deleteMeal(String id) async {
    await _mealRepository.deleteMeal(id);
    await _loadMeals();
  }
  
  // ... rest of your UI code
}
```

---

## Data Export/Import (Optional)

For backup purposes, you can add export/import functionality:

```dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataExportService {
  final MealRepository _mealRepository = MealRepository();

  /// Export all meals to JSON file
  Future<String> exportToJson() async {
    final meals = await _mealRepository.getAllMeals();
    final jsonData = meals.map((m) => m.toMap()).toList();
    
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/nutritrack_backup.json');
    await file.writeAsString(jsonEncode(jsonData));
    
    return file.path;
  }

  /// Import meals from JSON file
  Future<int> importFromJson(String filePath) async {
    final file = File(filePath);
    final jsonString = await file.readAsString();
    final List<dynamic> jsonData = jsonDecode(jsonString);
    
    int count = 0;
    for (final map in jsonData) {
      final meal = Meal.fromMap(map as Map<String, dynamic>);
      await _mealRepository.insertMeal(meal);
      count++;
    }
    
    return count;
  }
}
```

---

## Setup Checklist

### Initial Setup

- [ ] Add `sqflite` and `path` packages to `pubspec.yaml`
- [ ] Run `flutter pub get`
- [ ] Create `lib/database/` directory
- [ ] Create `database_helper.dart`
- [ ] Create `lib/repositories/` directory
- [ ] Create `meal_repository.dart`
- [ ] Update `meal.dart` model with `toMap()` and `fromMap()`

### Integration

- [ ] Replace sample data with repository calls
- [ ] Update HomeScreen to load from database
- [ ] Connect "Add Meal" form to `insertMeal()`
- [ ] Connect edit functionality to `updateMeal()`
- [ ] Connect delete functionality to `deleteMeal()`
- [ ] Update Stats tab to use repository queries

### Testing

- [ ] Test adding a meal
- [ ] Test editing a meal
- [ ] Test deleting a meal
- [ ] Test app restart (data persists)
- [ ] Test on Android/iOS/Web

### Optional

- [ ] Add data export functionality
- [ ] Add data import functionality
- [ ] Add settings storage
- [ ] Add database migration logic for future updates

---

## Platform Notes

| Platform | Database Location |
|----------|-------------------|
| **Android** | `/data/data/<package>/databases/` |
| **iOS** | App's Documents directory |
| **macOS** | App's support directory |
| **Windows** | `%APPDATA%` |
| **Linux** | `~/.local/share/<app>/` |
| **Web** | IndexedDB (requires `sqflite_common_ffi_web`) |

---

## Resources

- [sqflite Package Documentation](https://pub.dev/packages/sqflite)
- [SQLite Tutorial](https://www.sqlitetutorial.net/)
- [Flutter Cookbook - Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [path_provider Package](https://pub.dev/packages/path_provider)
