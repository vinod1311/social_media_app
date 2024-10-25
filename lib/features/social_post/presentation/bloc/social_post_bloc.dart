import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_medial_app/core/utils/shared_prefrence_helper.dart';
import 'package:social_medial_app/features/social_post/domain/repository/social_post_repository.dart';
import 'package:social_medial_app/features/social_post/domain/usecases/create_social_post_usecase.dart';
import 'package:social_medial_app/features/social_post/domain/usecases/fetch_post_usecase.dart';
import 'package:social_medial_app/features/social_post/domain/usecases/like_post_usecase.dart';
import 'package:social_medial_app/features/social_post/presentation/bloc/social_post_event.dart';
import 'package:social_medial_app/features/social_post/presentation/bloc/social_post_state.dart';
import '../../data/model/post.dart';

class SocialPostBloc extends Bloc<SocialPostEvent, SocialPostState> {
  final CreateSocialPostUsecase createSocialPostUsecase;
  final FetchPostsUsecase fetchPostsUsecase;
  final LikePostsUsecase likePostsUsecase;

  SocialPostBloc({required this.createSocialPostUsecase,required this.fetchPostsUsecase,required this.likePostsUsecase}) : super(SocialPostInitial()) {
    on<CreatePostEvent>(_onCreatePost);
    on<FetchPostsEvent>(_onFetchPosts);
    on<LikePostEvent>(_onLikePost);
  }

  //***************** CreatePostEvent
  Future<void> _onCreatePost(CreatePostEvent event, Emitter<SocialPostState> emit) async {
    try {
      await createSocialPostUsecase.call(message: event.message, username: event.username);
    } catch (e) {
      log("_onCreatePost message: e.toString() ${e.toString()}");
      emit(SocialPostError(message: e.toString()));
    }
  }

  //***************** FetchPostsEvent
  Future<void> _onFetchPosts(FetchPostsEvent event, Emitter<SocialPostState> emit) async {
    String uid = await SharedPreferencesHelper.getUserId();
    emit(SocialPostLoading());
    try {
      final Stream<List<Post>> postStream = fetchPostsUsecase.call(currentUserId: uid);
      await emit.forEach<List<Post>>(
        postStream,
        onData: (posts) => SocialPostsLoaded(posts: posts),
        onError: (error, stackTrace){
          log("_onFetchPosts onError: e.toString() ${error.toString()}");
          return  SocialPostError(message: error.toString());
        },
      );
    } catch (e) {
      log("_onFetchPosts message: e.toString() ${e.toString()}");
      emit(SocialPostError(message: e.toString()));
    }
  }

  // Future<void> _onLikePost(LikePostEvent event, Emitter<SocialPostState> emit) async {
  //   final currentState = state;
  //   if (currentState is SocialPostsLoaded) {
  //     final updatedPosts = currentState.posts.map((post) {
  //       if (post.id == event.postId) {
  //         post.isLiked = !post.isLiked;
  //         return post;
  //       }
  //       return post;
  //     }).toList();
  //
  //     emit(SocialPostsLoaded(posts: updatedPosts));
  //   }
  //
  //   try {
  //     await likePostsUsecase.call(postId: event.postId,userId:event.userId);
  //   } catch (e) {
  //     emit(LikePostError(message: e.toString()));
  //   }
  // }

  // Future<void> _onLikePost(LikePostEvent event, Emitter<SocialPostState> emit) async {
  //   final currentState = state;
  //
  //   if (currentState is SocialPostsLoaded) {
  //     final updatedPosts = currentState.posts.map((post) {
  //       if (post.id == event.postId) {
  //         post.isLiked = !post.isLiked;
  //         if (post.isLiked) {
  //           post.likes += 1;
  //         } else {
  //           post.likes -= 1;
  //         }
  //         return post;
  //       }
  //       return post;
  //     }).toList();
  //
  //     emit(SocialPostsLoaded(posts: updatedPosts));
  //
  //     try {
  //       // await likePostsUsecase.call(postId: event.postId, userId: event.userId);
  //       //
  //       // final updatedFromDB = await fetchPostsUsecase.call();
  //       // updatedFromDB.listen((posts){
  //       //   emit(SocialPostsLoaded(posts: posts));
  //       // });
  //
  //
  //     } catch (e) {
  //       emit(LikePostError(message: e.toString()));
  //       // final latestPosts = await fetchPostsUsecase.call();
  //       // latestPosts.listen((posts){
  //       //   emit(SocialPostsLoaded(posts: posts));
  //       // });
  //     }
  //   }
  // }

  Future<void> _onLikePost(LikePostEvent event, Emitter<SocialPostState> emit) async {
    final currentState = state;
    if (currentState is SocialPostsLoaded) {
      final updatedPosts = currentState.posts.map((post) {
        if (post.id == event.postId) {
          final updatedPost = Post(
            id: post.id,
            message: post.message,
            username: post.username,
            likes: post.isLiked ? post.likes - 1 : post.likes + 1,
            isLiked: !post.isLiked,
            timestamp: post.timestamp,
          );
          return updatedPost;
        }
        return post;
      }).toList();

      emit(SocialPostsLoaded(posts: updatedPosts));

      try {
        await likePostsUsecase.call(postId: event.postId, userId: event.userId);
      } catch (e) {
        emit(LikePostError(message: e.toString()));
      }
    }
  }

}
