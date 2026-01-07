import 'package:flutter/material.dart';

/// Model class representing a meal entry
class Meal {
  final String id;
  final String name;
  final DateTime date;
  final TimeOfDay time;

  const Meal({
    required this.id,
    required this.name,
    required this.date,
    required this.time,
  });

  /// Creates a copy of this meal with the given fields replaced
  Meal copyWith({
    String? id,
    String? name,
    DateTime? date,
    TimeOfDay? time,
  }) {
    return Meal(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}
