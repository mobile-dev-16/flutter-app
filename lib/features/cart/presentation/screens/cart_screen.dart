import 'package:flutter/material.dart';
import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      body: Center(
        child: Text(
          'Cart',
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}