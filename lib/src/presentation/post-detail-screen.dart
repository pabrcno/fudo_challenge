import 'package:flutter/material.dart';
import 'package:fudo_interview/src/api/post-api.dart';
import 'package:fudo_interview/src/models/post/post.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;

  const PostDetailScreen({super.key, required this.postId});

  @override
  _PostDetailScreenState createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final PostApi _postApi = PostApi();
  late Future<Post> _postFuture;

  @override
  void initState() {
    super.initState();
    _postFuture = _postApi.getPost(widget.postId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Post Detail'),
        ),
        body: FutureBuilder<Post>(
          future: _postFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While the future is loading
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              // If there was an error
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              // If the data is empty
              return const Center(child: Text('Post not found.'));
            } else {
              // If the future completed successfully with data
              final post = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text('User ID: ${post.userId}'),
                      const SizedBox(height: 16),
                      Text(post.body),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
