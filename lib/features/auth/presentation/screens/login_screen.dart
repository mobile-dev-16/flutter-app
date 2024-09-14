import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Text(
          'Login Screen',
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}