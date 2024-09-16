import 'package:dio/dio.dart';
import 'package:fudo_interview/src/api/api-service.dart';
import 'package:fudo_interview/src/models/user/user.dart';

class UserApi {
  final ApiService _api = ApiService();

  // Fetch all Users
  Future<List<User>> getUsers() async {
    try {
      Response response = await _api.dio.get('/users');
      List<User> users = (response.data as List)
          .map((user) => UserMapper.fromJson(user))
          .toList();
      return users;
    } catch (e) {
      throw Exception('Failed to load Users: $e');
    }
  }

  // Fetch a single User by ID
  Future<User> getUser(int id) async {
    try {
      Response response = await _api.dio.get('/users/$id');
      return UserMapper.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load User: $e');
    }
  }

  // Create a new User
  Future<User> createUser(User user) async {
    try {
      Response response = await _api.dio.post(
        '/users',
        data: user.toJson(),
      );
      return UserMapper.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create User: $e');
    }
  }
}
