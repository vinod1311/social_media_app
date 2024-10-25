
import 'package:social_medial_app/features/social_post/domain/repository/social_post_repository.dart';

import '../../data/model/post.dart';

class FetchPostsUsecase {
  final SocialPostRepository repository;

  FetchPostsUsecase({required this.repository});

  Stream<List<Post>> call({required String currentUserId}) {
    return repository.fetchPosts(currentUserId);
  }
}