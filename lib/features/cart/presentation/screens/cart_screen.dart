import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_state.dart';
import 'package:eco_bites/features/cart/presentation/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartBloc>(
      create: (BuildContext context) => CartBloc(<CartItemData>[
        CartItemData(
          id: '1',
          title: 'Pineapple Pizza',
          normalPrice: 32000,
          offerPrice: 28000,
        ),
        CartItemData(
          id: '2',
          title: 'Donut',
          normalPrice: 21000,
          offerPrice: 12000,
          quantity: 2,
        ),
        CartItemData(
          id: '3',
          title: 'Chesseburger',
          normalPrice: 15000,
          offerPrice: 12000,
        ),
      ]),
      child: const CartScreenContent(),
    );
  }
}

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (BuildContext context, int index) {
              final CartItemData item = state.items[index];
              return CartItem(
                id: item.id,
                imageUrl: item.imageUrl,
                title: item.title,
                normalPrice: item.normalPrice,
                offerPrice: item.offerPrice,
                quantity: item.quantity,
              );
            },
          );
        },
      ),
    );
  }
}
