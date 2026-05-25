import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/post.dart';
import '../services/post_service.dart';
import '../database_service.dart';
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
  final DatabaseService _dbService = DatabaseService();
  String? image;
  XFile? _pickedFile;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    // Resize and compress to keep Base64 string under 1MB Firestore limit
    _pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 70,
    );

    if (_pickedFile != null) setState(() => image = _pickedFile!.path);
  }

  Future<void> _handlePost() async {
    if (controller.text.isEmpty && image == null) return;

    setState(() => _isLoading = true);
    
    // Read the image as bytes to send to the service
    final bytes = await _pickedFile?.readAsBytes();

    try {
      // Upload to Firestore
      await _dbService.uploadPost(
        controller.text, 
        widget.username, 
        imageBytes: bytes,
      );

      if (mounted) {
        setState(() {
          controller.clear();
          image = null;
          _pickedFile = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                          onPressed: _isLoading ? null : _handlePost,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              : const Text("Post"),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2),
          ),
          Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: _dbService.getPostsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final docs = snapshot.data?.docs ?? [];

                      return ListView.builder(
                        itemCount: docs.length,
                        itemBuilder: (_, i) {
                          final post = Post.fromFirestore(docs[i]);
                          return PostCard(
                            post: post,
                            refresh: () => setState(() {}),
                          ).animate().fadeIn();
                        },
                      );
                    }),
          )
        ],
      ),
    );
  }
}