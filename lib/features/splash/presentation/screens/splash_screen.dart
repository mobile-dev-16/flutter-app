// ignore_for_file: use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/features/splash/presentation/bloc/splash_bloc.dart';
import 'package:eco_bites/features/splash/presentation/bloc/splash_event.dart';
import 'package:eco_bites/features/splash/presentation/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    super.key,
    required this.appLaunchTime,
    required this.networkInfo,
  });

  final DateTime appLaunchTime;
  final NetworkInfo networkInfo;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return BlocProvider<SplashBloc>(
      create: (BuildContext context) => SplashBloc()..add(AppStarted()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (BuildContext context, SplashState state) async {
          final DateTime mainPageRenderedTime = DateTime.now();
          final Duration loadTime =
              mainPageRenderedTime.difference(appLaunchTime);

          if (state is Authenticated) {
            try {
              if (await networkInfo.isConnected) {
                await logEvent(
                  milliseconds: loadTime.inMilliseconds,
                  authenticated: true,
                  eventName: 'splash_screen',
                );
              }
            } catch (e) {
              // Ignore logging errors when offline
            }
            Navigator.pushReplacementNamed(context, '/main');
          } else if (state is Unauthenticated) {
            try {
              if (await networkInfo.isConnected) {
                await logEvent(
                  milliseconds: loadTime.inMilliseconds,
                  authenticated: false,
                  eventName: 'splash_screen',
                );
              }
            } catch (e) {
              // Ignore logging errors when offline
            }
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(
            systemNavigationBarColor: theme.colorScheme.surfaceContainer,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
            backgroundColor: theme.colorScheme.surfaceContainer,
            body: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 240,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logEvent({
    required int milliseconds,
    required bool authenticated,
    required String eventName,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('logs').add(<String, dynamic>{
        'milliseconds': milliseconds,
        'authenticated': authenticated,
        'eventName': eventName,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail if logging fails
    }
  }
}
