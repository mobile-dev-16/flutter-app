// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/config/theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const materialTheme = MaterialTheme(Typography.blackCupertino);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: materialTheme.light().colorScheme.surface,
      systemNavigationBarIconBrightness: materialTheme.light().brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarColor: materialTheme.light().colorScheme.surface,
      statusBarIconBrightness: materialTheme.light().brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Waste',
      theme: materialTheme.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}