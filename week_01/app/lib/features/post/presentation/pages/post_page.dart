import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../bloc/post_event.dart';
import '../bloc/post_state.dart';

class PostPage extends StatelessWidget {
  const PostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clean Architecture — Bài viết'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại',
            onPressed: () {
              context.read<PostBloc>().add(RefreshPostsEvent());
            },
          ),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state is PostInitial || state is PostLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          } else if (state is PostLoaded) {
            if (state.posts.isEmpty) {
              return const Center(child: Text('Không có dữ liệu.'));
            }
            return RefreshIndicator(
              color: Colors.black,
              onRefresh: () async {
                context.read<PostBloc>().add(RefreshPostsEvent());
              },
              child: ListView.separated(
                itemCount: state.posts.length,
                separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.black12),
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      radius: 16,
                      child: Text(
                        '${post.id}',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(
                      post.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        post.body,
                        style: const TextStyle(color: Colors.black87, fontSize: 13),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is PostError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.black),
                    const SizedBox(height: 12),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Colors.black),
                      ),
                      onPressed: () {
                        context.read<PostBloc>().add(FetchPostsEvent());
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
