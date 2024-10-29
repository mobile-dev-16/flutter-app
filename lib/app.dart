import 'package:eco_bites/core/config/theme.dart';
import 'package:eco_bites/core/utils/create_text_theme.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/injection_container.dart';
import 'package:eco_bites/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcoBitesApp extends StatelessWidget {
  const EcoBitesApp({super.key, required this.appLaunchTime});

  final DateTime appLaunchTime;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness =
        View.of(context).platformDispatcher.platformBrightness;

    final TextTheme textTheme = createTextTheme(context, 'Roboto', 'Roboto');
    final MaterialTheme theme = MaterialTheme(textTheme);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor:
            Brightness.light == brightness ? Colors.white : Colors.black,
        systemNavigationBarIconBrightness:
            Brightness.light == brightness ? Brightness.dark : Brightness.light,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            Brightness.light == brightness ? Brightness.dark : Brightness.light,
      ),
    );
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      create: (_) => serviceLocator<AuthBloc>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Eco Bites',
        theme: brightness == Brightness.light ? theme.light() : theme.dark(),
        supportedLocales: const [
          Locale('en'),
        ],
        initialRoute: RouteGenerator.splashScreen,
        onGenerateRoute: (settings) => RouteGenerator.generateRoute(
          settings,
          appLaunchTime: appLaunchTime,
        ),
      ),
    );
  }
}
