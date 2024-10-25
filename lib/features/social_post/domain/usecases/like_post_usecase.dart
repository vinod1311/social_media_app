
import 'package:social_medial_app/features/social_post/domain/repository/social_post_repository.dart';

import '../../data/model/post.dart';

class LikePostsUsecase {
  final SocialPostRepository repository;

  LikePostsUsecase({required this.repository});

  Future<void> call({required String postId,required String userId}) {
    return repository.likePost(postId: postId,userId: userId);
  }
}