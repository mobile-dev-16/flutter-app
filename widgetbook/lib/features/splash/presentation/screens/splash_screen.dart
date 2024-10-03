import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/splash/presentation/screens/splash_screen.dart';

@widgetbook.UseCase(name: 'Default', type: SplashScreen)
Widget buildSplashScreenUseCase(BuildContext context) {
  return SplashScreen(appLaunchTime: DateTime.now(),);
}