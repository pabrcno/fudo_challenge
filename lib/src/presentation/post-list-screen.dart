import 'package:flutter/material.dart';
import 'package:fudo_interview/src/api/post-api.dart';

import 'package:fudo_interview/src/models/post/post.dart';
import 'package:fudo_interview/src/presentation/create-post-screen.dart';
import 'package:fudo_interview/src/presentation/post-detail-screen.dart';

class PostsListScreen extends StatefulWidget {
  const PostsListScreen({super.key});

  @override
  _PostsListScreenState createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  final PostApi _postApi = PostApi();
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = _postApi.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts List'),
      ),
      body: FutureBuilder<List<Post>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is loading
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there was an error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            // If the data is empty
            return const Center(child: Text('No posts found.'));
          } else {
            // If the future completed successfully with data
            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return ListTile(
                  title: Text(post.title),
                  subtitle: Text('User ID: ${post.userId}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetailScreen(postId: post.id),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
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
            setState(() {
              _postsFuture = _postApi.getPosts();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
