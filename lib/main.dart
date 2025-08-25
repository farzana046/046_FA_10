import 'package:flutter/material.dart';
import 'pages/sign_in_page.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SignInPage());
  }
}
