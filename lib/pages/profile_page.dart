import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final userEmail = authService.getCurrentUserEmail() ?? "Unknown";

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Logged in as:\n$userEmail", textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await authService.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
