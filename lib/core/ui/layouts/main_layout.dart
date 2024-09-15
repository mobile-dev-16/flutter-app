import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:eco_bites/core/ui/widgets/bottom_navbar.dart';
import 'package:eco_bites/features/home/presentation/screens/home_screen.dart';
import 'package:eco_bites/features/cart/presentation/screens/cart_screen.dart';
import 'package:eco_bites/features/orders/presentation/screens/order_list_screen.dart';
import 'package:eco_bites/features/profile/presentation/screens/profile_screen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const CartScreen(),
    const OrderListScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: theme.colorScheme.surfaceContainer,
      systemNavigationBarIconBrightness:
          theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness:
          theme.brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ));

    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}