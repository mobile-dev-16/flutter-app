import 'package:eco_bites/app.dart';
import 'package:eco_bites/firebase_options.dart';
import 'package:eco_bites/injection_container.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final DateTime appLaunchTime = DateTime.now();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebasePerformance.instance.setPerformanceCollectionEnabled(true);

  // Initialize dependency injection
  await setupServiceLocator();

  await dotenv.load();

  runApp(EcoBitesApp(appLaunchTime: appLaunchTime));
}
