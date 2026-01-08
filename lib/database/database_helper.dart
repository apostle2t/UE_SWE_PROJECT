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
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create database tables
  Future<void> _createDB(Database db, int version) async {
    // Create meals table
    await db.execute('''
      CREATE TABLE meals (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        meal_date TEXT NOT NULL,
        meal_time TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Create index for faster date queries
    await db.execute('CREATE INDEX idx_meals_date ON meals(meal_date)');

    // Create settings table for future use (dark mode preference, etc.)
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
  }

  /// Handle database migrations for future versions
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here when schema changes
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE meals ADD COLUMN calories INTEGER');
    // }
  }

  /// Close the database connection
  Future<void> close() async {
    final db = await instance.database;
    db.close();
    _database = null;
  }
}
