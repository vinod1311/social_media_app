import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_medial_app/core/utils/shared_prefrence_helper.dart';
import 'package:social_medial_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:social_medial_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:social_medial_app/features/social_post/presentation/bloc/social_post_bloc.dart';
import 'package:social_medial_app/features/social_post/presentation/bloc/social_post_event.dart';
import 'package:social_medial_app/features/social_post/presentation/bloc/social_post_state.dart';

class SocialPostScreen extends StatefulWidget {
  const SocialPostScreen({super.key});

  @override
  _SocialPostScreenState createState() => _SocialPostScreenState();
}

class _SocialPostScreenState extends State<SocialPostScreen> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timestamp){
      context.read<SocialPostBloc>().add(FetchPostsEvent());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(SignOutEvent(context));
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      labelText: 'Write a post...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                ElevatedButton(
                  onPressed: () async{
                    final message = messageController.text.trim();
                    String username = await SharedPreferencesHelper.getUserName() ?? "";
                    if (message.isNotEmpty) {
                      BlocProvider.of<SocialPostBloc>(context).add(
                        CreatePostEvent(
                          message: message,
                          username: username,
                        ),
                      );
                      BlocProvider.of<SocialPostBloc>(context).add(FetchPostsEvent());
                      messageController.clear();
                    }
                  },
                  child: const Text('Post'),
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<SocialPostBloc, SocialPostState>(
              builder: (context, state) {
                if (state is SocialPostLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is SocialPostsLoaded) {
                  final posts = state.posts;
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20.r,
                                  child: const Icon(Icons.person_outline),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        post.username,
                                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                          color: Theme.of(context).colorScheme.onPrimary
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      // Post message
                                      Text(post.message),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    post.isLiked ? Icons.favorite : Icons.favorite_border,
                                    color: post.isLiked ? Colors.red : Colors.grey,
                                  ),
                                  onPressed: () async {
                                    String userId = await SharedPreferencesHelper.getUserId();
                                    BlocProvider.of<SocialPostBloc>(context)
                                        .add(LikePostEvent(postId: post.id, userId: userId));
                                  },
                                ),
                                Text(post.likes.toString()),
                                SizedBox(width: 20.w),
                              ],
                            ),
                            Divider(color: Colors.grey[300]),
                          ],
                        ),
                      );
                    },
                  );
                }
                if (state is SocialPostError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return const Center(child: Text('No posts yet'));
              },
            ),
          )
        ],
      ),
    );
  }
}
