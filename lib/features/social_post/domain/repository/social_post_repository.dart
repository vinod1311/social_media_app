

import '../../data/model/post.dart';

abstract class SocialPostRepository {
  Future<void> createPost({required String message, required String username});
  Stream<List<Post>> fetchPosts(String currentUserId);
  Future<void> likePost({required String postId,required String userId});
}