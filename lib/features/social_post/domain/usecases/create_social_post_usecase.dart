
import '../repository/social_post_repository.dart';

class CreateSocialPostUsecase {
  final SocialPostRepository repository;

  CreateSocialPostUsecase({required this.repository});

  Future<void> call({required String message, required String username}) {
    return repository.createPost(message: message, username: username);
  }
}