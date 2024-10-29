import 'package:eco_bites/core/ui/layouts/main_layout.dart';
import 'package:eco_bites/features/auth/presentation/screens/login_screen.dart';
import 'package:eco_bites/features/auth/presentation/screens/register_screen.dart';
import 'package:eco_bites/features/splash/presentation/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String mainScreen = '/main';

  static Route<dynamic> generateRoute(
    RouteSettings settings, {
    required DateTime appLaunchTime,
  }) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(appLaunchTime: appLaunchTime),
        );
      case loginScreen:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case mainScreen:
        return MaterialPageRoute(
          builder: (_) => MainLayout(appLaunchTime: appLaunchTime),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
