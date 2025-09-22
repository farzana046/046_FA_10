import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool)? onThemeChange;

  const ProfilePage({super.key, this.isDarkMode = false, this.onThemeChange});

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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.dark_mode, color: Colors.grey),
                const SizedBox(width: 10),
                const Text("Dark Mode"),
                Switch(
                  value: isDarkMode,
                  onChanged: (value) {
                    if (onThemeChange != null) {
                      onThemeChange!(
                        value,
                      ); // triggers theme change in main.dart
                    }
                  },
                  activeColor: Theme.of(context).primaryColor,
                ),
              ],
            ),
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
