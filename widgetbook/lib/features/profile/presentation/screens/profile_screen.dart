import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/profile/presentation/screens/profile_screen.dart';

@widgetbook.UseCase(name: 'Default', type: ProfileScreen)
Widget buildProfileScreenUseCase(BuildContext context) {
  return const ProfileScreen();
}