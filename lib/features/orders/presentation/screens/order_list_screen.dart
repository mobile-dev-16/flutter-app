import 'package:flutter/material.dart';
import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: 'Orders'),
      body: Center(
        child: Text(
          'Order List',
          style: theme.textTheme.headlineMedium,
        ),
      ),
    );
  }
}