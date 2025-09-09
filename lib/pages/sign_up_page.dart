import 'package:flutter/material.dart';
import '../auth/auth_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final authService = AuthService();

  void signUp() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPassController.text;

    if (password != confirmPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match!")));
      return;
    }

    try {
      await authService.signUpWithEmailPassword(email, password);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign Up",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: signUp, child: const Text("Sign Up")),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Already have an account? Sign In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
