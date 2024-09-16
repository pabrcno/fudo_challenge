import 'package:dart_mappable/dart_mappable.dart';

part 'post.mapper.dart';

@MappableClass()
class Post with PostMappable {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });
}
