import 'package:eco_bites/core/ui/widgets/basic_image.dart';
import 'package:eco_bites/core/utils/date_utils.dart' as date_utils;
import 'package:eco_bites/features/orders/domain/models/order.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_item_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_item_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
    this.status = 'Delivered', // Default status
  });

  final Order order;
  final String status; // Make the status configurable

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderItemBloc>(
      create: (BuildContext context) => OrderItemBloc(status), // Use the provided status
      child: _buildOrderItem(context),
    );
  }

  Widget _buildOrderItem(BuildContext context) {
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
            BasicImage(imageUrl: order.imageUrl),
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
                          order.title,
                          style: theme.textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<OrderItemBloc, OrderItemState>(
                    builder: (BuildContext context, OrderItemState state) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            '${state.status}: ${date_utils.DateUtils.formatOrderDate(order.date)}',
                            style: theme.textTheme.bodyMedium,
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
}
