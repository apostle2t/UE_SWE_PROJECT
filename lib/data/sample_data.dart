import 'package:flutter/material.dart';
import '../models/meal.dart';

/// Sample meal data for demonstration purposes
class SampleData {
  SampleData._();

  static List<Meal> getSampleMeals() {
    return [
      Meal(
        id: '1',
        name: 'Steak',
        date: DateTime(2026, 1, 14),
        time: const TimeOfDay(hour: 17, minute: 13),
      ),
      Meal(
        id: '2',
        name: 'Chicken',
        date: DateTime(2026, 1, 7),
        time: const TimeOfDay(hour: 17, minute: 23),
      ),
      Meal(
        id: '3',
        name: 'Salad',
        date: DateTime(2026, 1, 5),
        time: const TimeOfDay(hour: 13, minute: 0),
      ),
      Meal(
        id: '4',
        name: 'Pasta',
        date: DateTime(2026, 1, 3),
        time: const TimeOfDay(hour: 19, minute: 45),
      ),
    ];
  }
}
