import '../database/database_helper.dart';
import '../models/meal.dart';

/// Repository class for meal CRUD operations
class MealRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  // ============ CREATE ============

  /// Insert a new meal into the database
  Future<void> insertMeal(Meal meal) async {
    final db = await _dbHelper.database;
    await db.insert('meals', meal.toMap());
  }

  // ============ READ ============

  /// Get all meals ordered by date and time (newest first)
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

  /// Get meals within a date range
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

  /// Get total meal count
  Future<int> getMealCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM meals');
    return result.first['count'] as int;
  }

  /// Get meals grouped by date (for history view)
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

  /// Get meal count for each day in the last N days
  Future<List<Map<String, dynamic>>> getDailyMealCounts(int days) async {
    final db = await _dbHelper.database;
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));

    final result = await db.rawQuery('''
      SELECT 
        meal_date,
        COUNT(*) as meal_count
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

  /// Get meals for the current week
  Future<List<Meal>> getMealsThisWeek() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getMealsByDateRange(startOfWeek, endOfWeek);
  }

  /// Search meals by name
  Future<List<Meal>> searchMeals(String query) async {
    final db = await _dbHelper.database;
    final maps = await db.query(
      'meals',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
      orderBy: 'meal_date DESC, meal_time DESC',
    );
    return maps.map((map) => Meal.fromMap(map)).toList();
  }
}
