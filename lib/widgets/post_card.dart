import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/post.dart';
import 'ui_card.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback refresh;

  const PostCard({super.key, required this.post, required this.refresh});

  @override
  Widget build(BuildContext context) {
    Widget img(String path) {
      // If the path is very long, it's likely a Base64 string from Firestore
      if (path.length > 500) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.memory(base64Decode(path), fit: BoxFit.cover),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: kIsWeb ? Image.network(path) : Image.file(File(path)),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: UICard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (post.content.isNotEmpty) Text(post.content),
              if (post.imagePath != null) ...[
                const SizedBox(height: 10),
                img(post.imagePath!),
              ],
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      post.isLiked
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: post.isLiked ? Colors.red : null,
                    ),
                    onPressed: () {
                      post.isLiked = !post.isLiked;
                      post.likes += post.isLiked ? 1 : -1;
                      refresh();
                    },
                  ),
                  Text('${post.likes}')
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}