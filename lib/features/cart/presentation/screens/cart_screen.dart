import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_state.dart';
import 'package:eco_bites/features/cart/presentation/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartScreenContent();
  }
}

class CartScreenContent extends StatelessWidget {
  const CartScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Cart'),
      body: Column(
        children: <Widget>[
          Expanded(
            child: BlocBuilder<CartBloc, CartState>(
              builder: (BuildContext context, CartState state) {
                return ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    final CartItemData item = state.items[index];
                    return CartItem(
                      item: item,
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          _buildCartSummary(context),
        ],
      ),
    );
  }

  Widget _buildCartSummary(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (BuildContext context, CartState state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Subtotal: \$${state.subtotal.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(ClearCart());
                    },
                    child: const Text('Delete All'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(CompletePurchase());
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Purchase Completed')),
                      );
                    },
                    child: const Text('Complete Purchase'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
