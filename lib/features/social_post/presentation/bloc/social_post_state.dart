
import '../../data/model/post.dart';

abstract class SocialPostState{}

class SocialPostInitial extends SocialPostState{}

class SocialPostLoading extends SocialPostState {}
class SocialPostsLoaded extends SocialPostState {
  final List<Post> posts;
  SocialPostsLoaded({required this.posts});
}
class SocialPostError extends SocialPostState {
  final String message;
  SocialPostError({required this.message});
}
class LikePostError extends SocialPostState {
  final String message;
  LikePostError({required this.message});
}
class LikePostSuccess extends SocialPostState {}