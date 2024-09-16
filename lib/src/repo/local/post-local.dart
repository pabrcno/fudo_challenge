import 'package:fudo_interview/src/models/post/post.dart';
import 'package:fudo_interview/src/repo/local/db.dart';
import 'package:sqflite/sqflite.dart';

class PostLocalDataSource {
  final db = DB.instance;

  PostLocalDataSource();

  Future<void> cachePosts(List<Post> posts) async {
    final batch = (await db.database).batch();
    for (var post in posts) {
      batch.insert(
        'posts',
        post.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit();
  }

  Future<List<Post>> getCachedPosts() async {
    final maps = await (await db.database).query('posts');
    return maps.map((map) => PostMapper.fromMap(map)).toList();
  }
}
