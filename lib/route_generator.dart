import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/core/ui/layouts/main_layout.dart';
import 'package:eco_bites/features/auth/presentation/screens/login_screen.dart';
import 'package:eco_bites/features/auth/presentation/screens/register_screen.dart';
import 'package:eco_bites/features/profile/presentation/screens/profile_screen.dart';
import 'package:eco_bites/features/splash/presentation/screens/splash_screen.dart';
import 'package:eco_bites/features/support/presentation/screens/support_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static const String splashScreen = '/';
  static const String loginScreen = '/login';
  static const String registerScreen = '/register';
  static const String mainScreen = '/main';
  static const String supportScreen = '/support';
  static const String profileScreen = '/profile';

  static Route<dynamic> generateRoute(
    RouteSettings settings, {
    required DateTime appLaunchTime,
    required NetworkInfo networkInfo,
  }) {
    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute<void>(
          builder: (_) => SplashScreen(
            appLaunchTime: appLaunchTime,
            networkInfo: networkInfo,
          ),
        );
      case loginScreen:
        return MaterialPageRoute<void>(builder: (_) => const LoginScreen());
      case registerScreen:
        return MaterialPageRoute<void>(builder: (_) => const RegisterScreen());
      case mainScreen:
        return MaterialPageRoute<void>(
          builder: (_) => MainLayout(appLaunchTime: appLaunchTime),
        );
      case supportScreen:
        return MaterialPageRoute<void>(builder: (_) => const SupportScreen());
      case profileScreen:
        return MaterialPageRoute<void>(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute<void>(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
}
