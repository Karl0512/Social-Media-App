import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String username;
  String content;
  String? imagePath;
  int likes;
  bool isLiked;

  Post({
    required this.username,
    required this.content,
    this.imagePath,
    this.likes = 0,
    this.isLiked = false,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return Post(
      username: data['username'] ?? 'Anonymous',
      content: data['text'] ?? '',
      imagePath: data['imagePath'],
      likes: data['likes'] ?? 0,
    );
  }
}