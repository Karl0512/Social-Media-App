import 'package:flutter/material.dart';
import 'database_service.dart';

class PostScreen extends StatefulWidget {
  final String username;

  const PostScreen({super.key, required this.username});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _textController = TextEditingController();
  final DatabaseService _dbService = DatabaseService();
  
  // State variable to handle loading
  bool _isLoading = false;

  void _handlePost() async {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    // Start loading state
    setState(() => _isLoading = true);

    try {
      await _dbService.uploadPost(text, widget.username);
      
      if (mounted) {
        // Clear input and show success only if the widget is still in the tree
        _textController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post published successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to post: ${e.toString()}')),
        );
      }
    } finally {
      // Stop loading regardless of outcome
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Post")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: "What's on your mind?",
                border: OutlineInputBorder(),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                // Button is disabled when onPressed is null
                onPressed: _isLoading ? null : _handlePost,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Post"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}