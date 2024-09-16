import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fudo_interview/src/api/post_api.dart';
import 'package:fudo_interview/src/api/user_api.dart';
import 'package:fudo_interview/src/models/post/post.dart';
import 'package:fudo_interview/src/models/user/user.dart';
import 'package:fudo_interview/src/presentation/create_post_screen.dart';
import 'package:fudo_interview/src/presentation/post_detail_screen.dart';

class PostsListScreen extends StatefulWidget {
  final PostApi postApi;
  final UserApi userApi;
  const PostsListScreen(
      {super.key, required this.postApi, required this.userApi});

  @override
  PostsListScreenState createState() => PostsListScreenState();
}

class PostsListScreenState extends State<PostsListScreen> {
  late Future<List<Post>> _postsFuture;
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  final _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.userApi.getUsers();
    _postsFuture = widget.postApi.getPosts();
    _postsFuture.then((posts) {
      setState(() {
        _posts = posts;
        _filteredPosts = posts;
      });
    });

    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    // Clean up the controller when the widget is disposed.
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Implement debounce to reduce API calls
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      // Filter the posts based on the search query
      String query = _searchController.text.trim();

      if (query.isEmpty) {
        // If the search query is empty, display all posts
        setState(() {
          _filteredPosts = _posts;
        });
        return;
      }

      // Fetch users whose names match the query
      final List<User> users = await widget.userApi.getUsersByName(query);

      // Get a set of user IDs from the fetched users
      final Set<int> userIds = users.map((user) => user.id).toSet();

      // Filter posts where the post's userId is in the userIds set
      setState(() {
        _filteredPosts =
            _posts.where((post) => userIds.contains(post.userId)).toList();
      });
    });
  }

  Future<void> _refreshPosts() async {
    // Refresh the posts list
    _postsFuture = widget.postApi.getPosts();
    List<Post> posts = await _postsFuture;
    setState(() {
      _posts = posts;
      _filteredPosts = posts;
    });
    _onSearchChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts List'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search posts by Author Name...',
                border: OutlineInputBorder(),
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      body: _posts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshPosts,
              child: _filteredPosts.isEmpty
                  ? const Center(child: Text('No posts found.'))
                  : ListView.builder(
                      itemCount: _filteredPosts.length,
                      itemBuilder: (context, index) {
                        final post = _filteredPosts[index];
                        return ListTile(
                          title: Text(post.title),
                          subtitle: Text('User ID: ${post.userId}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PostDetailScreen(postId: post.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CreatePostScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          ).then((_) {
            // Refresh the list after returning from CreatePostScreen
            _refreshPosts();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
