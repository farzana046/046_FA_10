import 'package:flutter/material.dart';
import 'pages/sign_in_page.dart';
import 'pages/sign_up_page.dart';
import 'pages/welcome_page.dart';
import 'pages/home_page.dart';
import 'auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url:
        'https://lodchnmkrqdtoamdeuqu.supabase.co', // replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvZGNobm1rcnFkdG9hbWRldXF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTYzNjAxMjMsImV4cCI6MjA3MTkzNjEyM30.hx242lmHZc9e4IkyqwUKlX0YNqOaF0kUDW8JlQTtOlU', // replace with your Supabase anon key
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInPage(),
        '/sign-up': (context) => const SignUpPage(),
        '/welcome': (context) => const WelcomePage(),
        '/home': (context) => const HomePage(),
      },
    );
  }
}
