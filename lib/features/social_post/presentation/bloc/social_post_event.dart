
abstract class SocialPostEvent {}

class CreatePostEvent extends SocialPostEvent {
  final String message;
  final String username;
  CreatePostEvent({required this.message, required this.username});
}
class FetchPostsEvent extends SocialPostEvent {}

class LikePostEvent extends SocialPostEvent {
  final String postId;
  final String userId;
  LikePostEvent({required this.postId,required this.userId});
}