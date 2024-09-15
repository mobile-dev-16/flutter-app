import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class BottomNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavbar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: theme.colorScheme.surfaceContainer,
      indicatorColor: theme.colorScheme.primary.withOpacity(0.2),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      destinations: const <NavigationDestination>[
        NavigationDestination(
          icon: Icon(Symbols.home_rounded),
          selectedIcon: Icon(Symbols.home_rounded, fill: 1),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Symbols.shopping_cart_rounded),
          selectedIcon: Icon(Symbols.shopping_cart_rounded, fill: 1),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Symbols.list_alt_rounded),
          selectedIcon: Icon(Symbols.list_alt_rounded, fill: 1),
          label: 'Orders',
        ),
        NavigationDestination(
          icon: Icon(Symbols.person_rounded),
          selectedIcon: Icon(Symbols.person_rounded, fill: 1),
          label: 'Profile',
        ),
      ],
    );
  }
}