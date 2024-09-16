import 'package:dio/dio.dart';
import 'package:fudo_interview/src/api/api_service.dart';
import 'package:fudo_interview/src/models/post/post.dart';
import 'package:fudo_interview/src/repo/local/post_local.dart';

class PostApi {
  final ApiService _api = ApiService();

  final _cache = PostLocalDataSource();

  // Fetch all posts
  Future<List<Post>> getPosts() async {
    try {
      Response response = await _api.dio.get('/posts');
      List<Post> posts = (response.data as List)
          .map((post) => PostMapper.fromMap(post))
          .toList();

      await _cache.cachePosts(posts);
      return posts;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        return await _cache.getCachedPosts();
      }
      rethrow;
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  } // Fetch a single post by ID

  Future<Post> getPost(int id) async {
    try {
      final cache = (await _cache.getCachedPosts());

      final cached = cache.where((post) => post.id == id).firstOrNull;
      if (cached != null) return cached;

      Response response = await _api.dio.get('/posts/$id');
      return PostMapper.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load post: $e');
    }
  }

  // Create a new post
  Future<Post> createPost(Post post) async {
    try {
      Response response = await _api.dio.post(
        '/posts',
        data: post.toJson(),
      );
      final newPost = PostMapper.fromMap(response.data);
      return newPost;
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }
}
