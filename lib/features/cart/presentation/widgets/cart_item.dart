import 'package:eco_bites/features/cart/presentation/bloc/cart_item_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_event.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_state.dart';
import 'package:eco_bites/features/cart/presentation/widgets/quantity_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItem extends StatelessWidget {
  const CartItem({
    super.key,
    this.imageUrl,
    required this.title,
    required this.normalPrice,
    required this.offerPrice,
    required this.initialQuantity,
  });

  final String? imageUrl;
  final String title;
  final double normalPrice;
  final double offerPrice;
  final int initialQuantity;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartItemBloc>(
      create: (BuildContext context) => CartItemBloc(initialQuantity),
      child: BlocBuilder<CartItemBloc, CartItemState>(
        builder: (BuildContext context, CartItemState state) {
          return _buildCartItem(context, state);
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItemState state) {
    final ThemeData theme = Theme.of(context);

    return Card(
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
                    style: theme.textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Text(
                        '\$${offerPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '\$${normalPrice.toStringAsFixed(2)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  QuantityInput(
                    initialValue: state.quantity,
                    onChanged: (int value) {
                      context.read<CartItemBloc>().add(QuantityChanged(value));
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
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return Image.network(
        imageUrl!,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder:
            (BuildContext context, Object error, StackTrace? stackTrace) =>
                _buildPlaceholder(theme),
      );
    } else {
      return _buildPlaceholder(theme);
    }
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      color: theme.colorScheme.surfaceContainerHigh,
      child: Icon(
        Icons.image,
        size: 40,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
