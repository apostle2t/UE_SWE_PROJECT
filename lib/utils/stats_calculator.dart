import '../models/meal.dart';

/// Utility class for calculating meal statistics
class StatsCalculator {
  StatsCalculator._();

  /// Calculates the number of meals logged this week
  static int getMealsThisWeek(List<Meal> meals) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    return meals
        .where((meal) =>
            meal.date.isAfter(startOfWeek.subtract(const Duration(days: 1))))
        .length;
  }

  /// Calculates the number of meals logged this month
  static int getMealsThisMonth(List<Meal> meals) {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return meals
        .where((meal) =>
            meal.date.isAfter(startOfMonth.subtract(const Duration(days: 1))))
        .length;
  }

  /// Calculates the current day streak
  static int calculateDayStreak(List<Meal> meals) {
    if (meals.isEmpty) return 0;

    // Get unique dates sorted in descending order
    List<DateTime> uniqueDates = meals
        .map((m) => DateTime(m.date.year, m.date.month, m.date.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a));

    if (uniqueDates.isEmpty) return 0;

    DateTime today = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
    );

    // Check if there's a meal today or yesterday
    if (uniqueDates.first.difference(today).inDays.abs() > 1) {
      return 0;
    }

    int streak = 1;
    for (int i = 0; i < uniqueDates.length - 1; i++) {
      if (uniqueDates[i].difference(uniqueDates[i + 1]).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }

  /// Gets meals per day for the last 7 days
  static List<int> getMealsPerDayLastWeek(List<Meal> meals) {
    List<int> mealsPerDay = [];

    for (int i = 6; i >= 0; i--) {
      DateTime day = DateTime.now().subtract(Duration(days: i));
      int count = meals
          .where((m) =>
              m.date.year == day.year &&
              m.date.month == day.month &&
              m.date.day == day.day)
          .length;
      mealsPerDay.add(count);
    }

    return mealsPerDay;
  }
}
