import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/auth/presentation/screens/login_screen.dart';

@widgetbook.UseCase(name: 'Default', type: LoginScreen)
Widget buildLoginScreenUseCase(BuildContext context) {
  return const LoginScreen();
}
