// lib/app.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/config/theme.dart';
import 'core/utils/create_text_theme.dart';
import 'features/splash/presentation/screens/splash_screen.dart';
import 'features/home/presentation/screens/home_screen.dart';
import 'features/auth/presentation/screens/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;

    // Use with Google Fonts package to use downloadable fonts
    TextTheme textTheme = createTextTheme(context, "Roboto", "Roboto");

    MaterialTheme theme = MaterialTheme(textTheme);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Brightness.light == brightness ? Colors.white : Colors.black,
      systemNavigationBarIconBrightness: Brightness.light == brightness ? Brightness.dark : Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light == brightness ? Brightness.dark : Brightness.light,
    ));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food Waste',
      theme: brightness == Brightness.light ? theme.light() : theme.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}