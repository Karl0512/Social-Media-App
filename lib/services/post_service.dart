import '../models/post.dart';

class PostService {
  static final List<Post> posts = [];

  static void addPost(Post post) {
    posts.insert(0, post);
  }
}