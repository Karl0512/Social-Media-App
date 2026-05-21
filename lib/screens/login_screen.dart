import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import '../widgets/ui_card.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primary, AppTheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: UICard(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Socially",
                        style: TextStyle(
                            fontSize: 34, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => HomeScreen(
                                username: controller.text.isEmpty
                                    ? "Guest"
                                    : controller.text,
                              ),
                            ),
                          );
                        },
                        child: const Text("Continue"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}