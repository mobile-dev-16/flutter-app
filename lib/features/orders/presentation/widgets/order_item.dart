import 'package:eco_bites/core/ui/widgets/basic_image.dart';
import 'package:eco_bites/core/utils/date_utils.dart' as date_utils;
import 'package:eco_bites/features/orders/domain/models/order.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_item_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_item_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const double cardBorderRadius = 24.0;
const EdgeInsets cardMargin = EdgeInsets.symmetric(vertical: 8, horizontal: 16);
const EdgeInsets cardPadding = EdgeInsets.all(16);
const double spaceBetweenElements = 16.0;

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
    this.status = 'Delivered',
  });

  final Order order;
  final String status;

  // Helper method to map the enum value to a user-friendly text.
  String _mapStatusToText(OrderItemStatus status) {
    switch (status) {
      case OrderItemStatus.pending:
        return 'Pending';
      case OrderItemStatus.processing:
        return 'Processing';
      case OrderItemStatus.shipped:
        return 'Shipped';
      case OrderItemStatus.delivered:
        return 'Delivered';
      case OrderItemStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Helper method to convert String to OrderItemStatus
  OrderItemStatus _mapStatus(String status) {
    return OrderItemStatus.values.firstWhere(
      (OrderItemStatus e) => e.toString().split('.').last == status.toLowerCase(),
      orElse: () => OrderItemStatus.delivered, // Default to delivered if not found
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderItemBloc>(
      create: (BuildContext context) => OrderItemBloc(_mapStatus(status)), // Convert String to OrderItemStatus
      child: _buildOrderItem(context),
    );
  }

  Widget _buildOrderItem(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      margin: cardMargin,
      child: Padding(
        padding: cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BasicImage(imageUrl: order.imageUrl),
            const SizedBox(width: spaceBetweenElements),
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
                  const SizedBox(height: spaceBetweenElements),
                  BlocBuilder<OrderItemBloc, OrderItemState>(
                    builder: (BuildContext context, OrderItemState state) {
                      final String statusText = _mapStatusToText(state.status);

                      return Row(
                        children: <Widget>[
                          // Status text
                          Text(
                            statusText,
                            style: theme.textTheme.bodyMedium,
                          ),
                          // Add some space between the status and date
                          const SizedBox(width: 10),
                          // Date text aligned next to the status
                          Text(
                            date_utils.DateUtils.formatDayMonth(order.date),
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
