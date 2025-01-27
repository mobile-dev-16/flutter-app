import 'package:eco_bites/core/blocs/bloc_resetter.dart';
import 'package:eco_bites/core/blocs/internet_connection/internet_connection_bloc.dart';
import 'package:eco_bites/core/config/theme.dart';
import 'package:eco_bites/core/network/network_info.dart';
import 'package:eco_bites/core/utils/create_text_theme.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:eco_bites/features/support/presentation/bloc/support_bloc.dart';
import 'package:eco_bites/injection_container.dart';
import 'package:eco_bites/route_generator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EcoBitesApp extends StatelessWidget {
  const EcoBitesApp({
    super.key,
    required this.appLaunchTime,
    required this.analytics,
  });

  final DateTime appLaunchTime;
  final FirebaseAnalytics analytics;

  @override
  Widget build(BuildContext context) {
    final Brightness brightness =
        View.of(context).platformDispatcher.platformBrightness;

    final TextTheme textTheme = createTextTheme(context, 'Roboto', 'Roboto');
    final MaterialTheme theme = MaterialTheme(textTheme);

    final SystemUiOverlayStyle systemUiStyle = SystemUiOverlayStyle(
      systemNavigationBarColor:
          Brightness.light == brightness ? Colors.white : Colors.black,
      systemNavigationBarIconBrightness:
          Brightness.light == brightness ? Brightness.dark : Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          Brightness.light == brightness ? Brightness.dark : Brightness.light,
    );

    SystemChrome.setSystemUIOverlayStyle(systemUiStyle);
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiBlocProvider(
      providers: <BlocProvider<dynamic>>[
        BlocProvider<AuthBloc>(create: (_) => serviceLocator<AuthBloc>()),
        BlocProvider<AddressBloc>(create: (_) => serviceLocator<AddressBloc>()),
        BlocProvider<OrderBloc>(create: (_) => serviceLocator<OrderBloc>()),
        BlocProvider<CartBloc>(create: (_) => serviceLocator<CartBloc>()),
        BlocProvider<FoodBusinessBloc>(
          create: (_) => serviceLocator<FoodBusinessBloc>(),
        ),
        BlocProvider<InternetConnectionBloc>(
          create: (_) => serviceLocator<InternetConnectionBloc>(),
        ),
        BlocProvider<ProfileBloc>(
          create: (_) => serviceLocator<ProfileBloc>(),
        ),
        BlocProvider<SupportBloc>(create: (_) => serviceLocator<SupportBloc>()),
      ],
      child: BlocResetter(
        child: MaterialApp(
          navigatorObservers: <NavigatorObserver>[
            FirebaseAnalyticsObserver(analytics: analytics),
          ],
          debugShowCheckedModeBanner: false,
          title: 'Eco Bites',
          theme: brightness == Brightness.light ? theme.light() : theme.dark(),
          supportedLocales: const <Locale>[
            Locale('en'),
          ],
          initialRoute: RouteGenerator.splashScreen,
          onGenerateRoute: (RouteSettings settings) =>
              RouteGenerator.generateRoute(
            settings,
            appLaunchTime: appLaunchTime,
            networkInfo: serviceLocator<NetworkInfo>(),
          ),
        ),
      ),
    );
  }
}
