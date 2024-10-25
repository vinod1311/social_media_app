
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_medial_app/features/social_post/domain/repository/social_post_repository.dart';
import '../model/post.dart';

class SocialPostDataSource implements SocialPostRepository{

  final FirebaseFirestore firestore;

  SocialPostDataSource({required this.firestore});

  @override
  Future<void> createPost({required String message, required String username}) async {
    await firestore.collection('posts').add({
      'message': message,
      'username': username,
      'timestamp': FieldValue.serverTimestamp(),
      'likes':0
    });
  }

  @override
  Stream<List<Post>> fetchPosts(String currentUserId) {
    return firestore.collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      return await Future.wait(snapshot.docs.map((doc) async {
        final timestamp = doc['timestamp'] as Timestamp?;
        final reactionSnapshot = await doc.reference.collection('reactions').doc(currentUserId).get();
        final isLiked = reactionSnapshot.exists;
        return Post(
          id: doc.id,
          message: doc['message'],
          username: doc['username'],
          likes: doc['likes'],
          isLiked: isLiked,
          timestamp: timestamp != null ? timestamp.toDate() : DateTime.now(),
        );
      }).toList());
    });
  }

  @override
  Future<void> likePost({required String postId,required String userId}) async {
    final postRef = firestore.collection('posts').doc(postId);
    final reactionRef = postRef.collection('reactions').doc(userId);

    final reactionSnapshot = await reactionRef.get();

    if (reactionSnapshot.exists) {
      await postRef.update({
        'likes': FieldValue.increment(-1),
      });
      await reactionRef.delete();
    } else {
      await postRef.update({
        'likes': FieldValue.increment(1),
      });
      await reactionRef.set({'reaction': 'like'});
    }
  }


}