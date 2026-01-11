import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// Singleton helper class for SQLite database operations
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Get the database instance (creates it if it doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('nutritrack.db');
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async {
        // Enable foreign keys if needed in future tables
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    final batch = db.batch();

    // Create meals table
    batch.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        meal_date INTEGER NOT NULL,
        meal_time INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      )
    ''');

    // Index for faster date queries
    batch.execute('CREATE INDEX idx_meals_date ON meals(meal_date)');

    // Settings table for future preferences
    batch.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');

    await batch.commit();
  }

  /// Handle database migrations for future versions
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Example for future schema changes:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE meals ADD COLUMN calories INTEGER DEFAULT 0');
    // }
  }

  /// Close the database safely
  Future<void> close() async {
    if (_database != null && _database!.isOpen) {
      await _database!.close();
      _database = null;
    }
  }

  // --------------------
  // CRUD Helper Methods
  // --------------------

  /// Insert a meal
  Future<int> insertMeal(Map<String, dynamic> meal) async {
    final db = await instance.database;
    return await db.insert('meals', meal);
  }

  /// Update a meal by ID
  Future<int> updateMeal(Map<String, dynamic> meal, String id) async {
    final db = await instance.database;
    return await db.update(
      'meals',
      meal,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a meal by ID
  Future<int> deleteMeal(String id) async {
    final db = await instance.database;
    return await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Get all meals, optionally filtered by date
  Future<List<Map<String, dynamic>>> getMeals({int? mealDate}) async {
    final db = await instance.database;
    if (mealDate != null) {
      return await db.query(
        'meals',
        where: 'meal_date = ?',
        whereArgs: [mealDate],
        orderBy: 'meal_time ASC',
      );
    } else {
      return await db.query('meals', orderBy: 'meal_date ASC, meal_time ASC');
    }
  }

  /// Insert or update a setting
  Future<void> setSetting(String key, String value) async {
    final db = await instance.database;
    await db.insert(
      'settings',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get a setting by key
  Future<String?> getSetting(String key) async {
    final db = await instance.database;
    final result =
        await db.query('settings', where: 'key = ?', whereArgs: [key]);
    if (result.isNotEmpty) {
      return result.first['value'] as String;
    }
    return null;
  }
}
