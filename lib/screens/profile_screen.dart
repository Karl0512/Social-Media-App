import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 220,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF4F46E5), Color(0xFF9333EA)],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(username,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}