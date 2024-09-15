import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

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
