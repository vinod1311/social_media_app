class Post {
  String id;
  String message;
  String username;
  int likes;
  bool isLiked;
  final DateTime timestamp;

  Post({required this.id, required this.message, required this.username,required this.likes, required this.timestamp,required this.isLiked});
}