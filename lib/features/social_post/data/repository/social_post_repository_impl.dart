


import 'package:social_medial_app/features/social_post/data/data_sources/social_post_data_source.dart';

import '../../domain/repository/social_post_repository.dart';
import '../model/post.dart';

class SocialPostRepositoryImpl implements SocialPostRepository{
  final SocialPostDataSource _socialPostDataSource;

  const SocialPostRepositoryImpl(this._socialPostDataSource);

  @override
  Future<void> createPost({required String message, required String username}) async {
    await _socialPostDataSource.createPost(message: message, username: username);
  }

  @override
  Stream<List<Post>> fetchPosts(String currentUserId) {
    return _socialPostDataSource.fetchPosts(currentUserId);
  }

  @override
  Future<void> likePost({required String postId,required String userId}) {
    return _socialPostDataSource.likePost(postId:postId,userId: userId);
  }



  
}