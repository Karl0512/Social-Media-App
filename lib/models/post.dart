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
}