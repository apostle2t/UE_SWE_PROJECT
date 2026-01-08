import 'package:flutter/material.dart';

/// Model class representing a meal entry
class Meal {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay time;
  final DateTime createdAt;
  final DateTime updatedAt;

  Meal({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  /// Convert Meal to Map for SQLite storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'meal_date': date.toIso8601String().split('T')[0], // YYYY-MM-DD
      'meal_time':
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
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
      date: DateTime.parse(map['meal_date'] as String),
      time: TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1]),
      ),
      createdAt: DateTime.parse(map['created_at'] as String),
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  /// Creates a copy of this meal with the given fields replaced
  Meal copyWith({
    String? id,
    String? name,
    DateTime? date,
    TimeOfDay? time,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Generate a unique ID based on timestamp
  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
