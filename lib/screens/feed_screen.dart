import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../widgets/post_card.dart';
import '../widgets/ui_card.dart';

class FeedScreen extends StatefulWidget {
  final String username;

  const FeedScreen({super.key, required this.username});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final controller = TextEditingController();
  String? image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) setState(() => image = file.path);
  }

  void post() {
    if (controller.text.isEmpty && image == null) return;

    PostService.addPost(Post(
      username: widget.username,
      content: controller.text,
      imagePath: image,
    ));

    setState(() {
      controller.clear();
      image = null;
    });
  }

  Widget renderImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: kIsWeb
          ? Image.network(path)
          : Image.file(File(path)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Feed"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: UICard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "What's happening?",
                        border: InputBorder.none,
                      ),
                    ),
                    if (image != null) ...[
                      const SizedBox(height: 10),
                      renderImage(image!),
                    ],
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image_outlined),
                          onPressed: pickImage,
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: post,
                          child: const Text("Post"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: PostService.posts.length,
              itemBuilder: (_, i) => PostCard(
                post: PostService.posts[i],
                refresh: () => setState(() {}),
              ).animate().fadeIn(),
            ),
          )
        ],
      ),
    );
  }
}