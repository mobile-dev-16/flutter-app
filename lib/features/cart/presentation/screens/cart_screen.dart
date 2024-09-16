import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/features/cart/presentation/widgets/cart_item.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      body: ListView(
        children: const <Widget>[
          CartItem(
            title: 'Organic Apples',
            normalPrice: 32800,
            offerPrice: 20400,
            initialQuantity: 1,
          ),
          CartItem(
            title: 'Fresh Carrots',
            normalPrice: 42200,
            offerPrice: 25300,
            initialQuantity: 2,
          ),
        ],
      ),
    );
  }
}
