import 'package:fudo_interview/src/models/user/user.dart';
import 'package:fudo_interview/src/repo/local/db.dart';
import 'package:sqflite/sqflite.dart';

class UserLocalDataSource {
  final db = DB.instance;

  Future<void> cacheUsers(List<User> users) async {
    final batch = (await db.database).batch();
    for (var user in users) {
      batch.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<User>> getCachedUsers() async {
    final maps = await (await db.database).query('users');
    return maps.map((map) => UserMapper.fromMap(map)).toList();
  }

  Future<User> getCachedUserById(int id) async {
    final dbClient = await db.database;
    final maps = await dbClient.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    return UserMapper.fromMap(maps[0]);
  }

  Future<List<User>> getCachedUsersByName(String name) async {
    final dbClient = await db.database;
    final maps = await dbClient.query(
      'users',
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
    );
    return maps.map((map) => UserMapper.fromMap(map)).toList();
  }
}
