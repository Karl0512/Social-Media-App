import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String username;

  const HomeScreen({super.key, required this.username});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      FeedScreen(username: widget.username),
      ProfileScreen(username: widget.username),
    ];

    return Scaffold(
      body: pages[index],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) => setState(() => index = i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home_outlined), label: "Feed"),
              NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
            ],
          ),
        ),
      ),
    );
  }
}