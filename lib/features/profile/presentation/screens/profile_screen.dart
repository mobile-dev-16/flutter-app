import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile'),
      body: Center(
        child: Text(
          'Profile',
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}
