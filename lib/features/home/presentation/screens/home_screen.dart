import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Text(
          'Home Screen',
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
