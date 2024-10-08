import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fudo_interview/src/api/api_service.dart';
import 'package:fudo_interview/src/models/user/user.dart';
import 'package:fudo_interview/src/repo/local/user_local.dart';

class UserApi {
  final ApiService _api = ApiService();
  final _cache = UserLocalDataSource();
  // Fetch all Users
  Future<List<User>> getUsers() async {
    try {
      Response response = await _api.dio.get('/users');
      List<User> users = (response.data as List)
          .map((user) => UserMapper.fromMap(user))
          .toList();
      _cache.cacheUsers(users);
      return users;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return await _cache.getCachedUsers();
      }
      return [];
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to load Users: $e');
    }
  }

  Future<List<User>> getUsersByName(String name) async {
    try {
      // NOTE: The api does not have an endpoint for partial search.
      Response response = await _api.dio.get(
        '/users?name=$name',
      );
      List<User> users = (response.data as List)
          .map((user) => UserMapper.fromMap(user))
          .toList();
      // If there are no users, do cache search
      if (users.isEmpty) {
        users.addAll(await _cache.getCachedUsersByName(name));
      }
      return users;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return await _cache.getCachedUsersByName(name);
      }
      return [];
    } catch (e) {
      log(e.toString());
      throw Exception('Failed to create User: $e');
    }
  }
}
