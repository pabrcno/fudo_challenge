// db.dart
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  // Private constructor
  DB._privateConstructor();

  // Single instance
  static final DB instance = DB._privateConstructor();

  // Database reference
  static Database? _database;

  // Getter for the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the database if it doesn't exist
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the default databases location
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'my_database_1.db');

    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  // Method to create tables by delegating to repositories
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        username TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE posts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        title TEXT, 
        body TEXT,
        FOREIGN KEY(userId) REFERENCES users(id)
      )
    ''');
  }

  // Handle database upgrades
  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Perform migration or alteration of tables
      // Example:
      // await db.execute('ALTER TABLE users ADD COLUMN age INTEGER');
    }
  }

  // Close the database
  Future close() async {
    Database db = await instance.database;
    db.close();
  }
}
