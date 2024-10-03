import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/home/presentation/screens/home_screen.dart';

@widgetbook.UseCase(name: 'Default', type: HomeScreen)
Widget buildHomeScreenUseCase(BuildContext context) {
  return HomeScreen(appLaunchTime: DateTime.now());
}