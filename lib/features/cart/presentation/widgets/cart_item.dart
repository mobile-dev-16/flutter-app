import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_state.dart';
import 'package:eco_bites/features/cart/presentation/widgets/quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.id,
    this.imageUrl,
    required this.title,
    required this.normalPrice,
    required this.offerPrice,
    required this.quantity,
  });

  final String id;
  final String? imageUrl;
  final String title;
  final double normalPrice;
  final double offerPrice;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartItemBloc>(
      create: (BuildContext context) => CartItemBloc(quantity),
      child: _buildCartItem(context),
    );
  }

  Widget _buildCartItem(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _buildImage(theme),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CartItemBloc, CartItemState>(
                    builder: (BuildContext context, CartItemState state) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  '${(offerPrice * state.quantity).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} COP',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme
                                        .colorScheme.onSecondaryFixedVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${(normalPrice * state.quantity).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} COP',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          QuantityInput(
                            onIncrease: () {
                              context.read<CartItemBloc>().add(
                                    const QuantityChanged(
                                      QuantityChangeType.increase,
                                    ),
                                  );
                              context.read<CartBloc>().add(
                                    CartItemQuantityChanged(
                                      id,
                                      state.quantity + 1,
                                    ),
                                  );
                            },
                            onDecrease: () {
                              if (state.quantity > 1) {
                                context.read<CartItemBloc>().add(
                                      const QuantityChanged(
                                        QuantityChangeType.decrease,
                                      ),
                                    );
                                context.read<CartBloc>().add(
                                      CartItemQuantityChanged(
                                        id,
                                        state.quantity - 1,
                                      ),
                                    );
                              } else {
                                context
                                    .read<CartBloc>()
                                    .add(CartItemRemoved(id));
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme) {
    if (imageUrl != null) {
      return Image.network(
        imageUrl!,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
      );
    } else {
      return Container(
        width: 64,
        height: 64,
        color: theme.colorScheme.secondary,
        child: Icon(
          Icons.image,
          color: theme.colorScheme.onSecondary,
          size: 32,
        ),
      );
    }
  }
}
