// db_test.dart
import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_interview/src/repo/local/db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // Initialize sqflite for desktop testing
  sqfliteFfiInit();

  // Set sqflite to use the ffi implementation
  databaseFactory = databaseFactoryFfi;

  // Close the database after each test
  // tearDown(() async {
  //   await DB.instance.close();
  // });

  test('Database is initialized correctly', () async {
    final db = await DB.instance.database;

    // Verify that tables exist
    var result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='users';");
    expect(result.length, 1);

    result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='posts';");
    expect(result.length, 1);
  });

  test('Users table has correct columns', () async {
    final db = await DB.instance.database;

    log(db.isOpen.toString());
    var result = await db.rawQuery('PRAGMA table_info(users);');
    var columns = result.map((row) => row['name']).toList();

    expect(columns, containsAll(['id', 'name', 'email', 'username']));
  });
}
