import 'package:eco_bites/core/ui/widgets/bottom_navbar.dart';
import 'package:eco_bites/core/utils/analytics_logger.dart';
import 'package:eco_bites/features/cart/presentation/screens/cart_screen.dart';
import 'package:eco_bites/features/home/presentation/bloc/home_bloc.dart';
import 'package:eco_bites/features/home/presentation/screens/home_screen.dart';
import 'package:eco_bites/features/orders/presentation/screens/order_list_screen.dart';
import 'package:eco_bites/features/profile/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key, required this.appLaunchTime});

  final DateTime appLaunchTime;

  @override
  MainLayoutState createState() => MainLayoutState();
}

class MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = <Widget>[
      BlocProvider<HomeBloc>(
        create: (BuildContext context) => HomeBloc(),
        child: HomeScreen(
          appLaunchTime: widget.appLaunchTime,
        ),
      ),
      const CartScreen(),
      const OrderListScreen(),
      const ProfileScreen(),
    ];
  }

  void _onItemTapped(int index) {
    final List<String> screenNames = <String>[
      'home',
      'cart',
      'orders',
      'profile',
    ];

    AnalyticsLogger.logEvent(
      eventName: 'navigation',
      additionalData: <String, dynamic>{
        'screen': screenNames[index],
        'previous_screen': screenNames[_currentIndex],
      },
    );

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: theme.colorScheme.surfaceContainer,
        systemNavigationBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: theme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
    );

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
