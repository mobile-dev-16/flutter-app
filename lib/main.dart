import 'package:eco_bites/app.dart';
import 'package:eco_bites/firebase_options.dart';
import 'package:eco_bites/injection_container.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

Future<void> logLoadingTime(String screenName, int milliseconds) async {
  await analytics.logEvent(
    name: 'loading_time',
    parameters: <String, Object>{
      'screen_name': screenName,
      'milliseconds': milliseconds,
    },
  );
}

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

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  runApp(EcoBitesApp(appLaunchTime: appLaunchTime, analytics: analytics));
}
