import 'package:dart_mappable/dart_mappable.dart';

part 'user.mapper.dart';

@MappableClass()
class User with UserMappable {
  final int id;
  final String username;
  final String email;
  final String name;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.name});
}
