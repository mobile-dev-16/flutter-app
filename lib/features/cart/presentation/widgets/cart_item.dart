import 'package:eco_bites/core/ui/widgets/basic_image.dart';
import 'package:eco_bites/core/ui/widgets/price_display.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_state.dart';
import 'package:eco_bites/features/cart/presentation/widgets/quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    required this.item,
  });

  final CartItemData item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartItemBloc>(
      create: (BuildContext context) => CartItemBloc(item.quantity),
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
            BasicImage(imageUrl: item.imageUrl),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          item.title,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: IconButton(
                          icon: const Icon(Symbols.close_rounded, size: 18),
                          onPressed: () => _onDelete(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CartItemBloc, CartItemState>(
                    builder: (BuildContext context, CartItemState state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Expanded(
                            child: PriceDisplay(
                              offerPrice: item.offerPrice * state.quantity,
                              normalPrice: item.normalPrice * state.quantity,
                            ),
                          ),
                          QuantityInput(
                            onIncrease: () => _onIncrease(context, state),
                            onDecrease: () => _onDecrease(context, state),
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

  void _onIncrease(BuildContext context, CartItemState state) {
    context.read<CartItemBloc>().add(
          const QuantityChanged(QuantityChangeType.increase),
        );
    context.read<CartBloc>().add(
          CartItemQuantityChanged(item.id, state.quantity + 1),
        );
  }

  void _onDecrease(BuildContext context, CartItemState state) {
    if (state.quantity > 1) {
      context.read<CartItemBloc>().add(
            const QuantityChanged(QuantityChangeType.decrease),
          );
      context.read<CartBloc>().add(
            CartItemQuantityChanged(item.id, state.quantity - 1),
          );
    } else {
      context.read<CartBloc>().add(CartItemRemoved(item.id));
    }
  }

  void _onDelete(BuildContext context) {
    context.read<CartBloc>().add(CartItemRemoved(item.id));
  }
}
