import 'package:eco_bites/core/utils/date_utils.dart' as date_utils;
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:flutter/material.dart';

const double cardBorderRadius = 24.0;
const EdgeInsets cardMargin = EdgeInsets.symmetric(vertical: 8, horizontal: 16);
const EdgeInsets cardPadding = EdgeInsets.all(16);
const double spaceBetweenElements = 12.0;

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.order,
    required this.onTap,
  });

  final order_entity.Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cardBorderRadius),
      ),
      margin: cardMargin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(cardBorderRadius),
        child: Padding(
          padding: cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // Business Name
              Text(
                order.businessName,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: spaceBetweenElements),

              // Status and Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      order.status.displayName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _getStatusColor(order.status),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(
                    date_utils.DateUtils.formatDayMonth(order.createdAt),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color:
                          theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(order_entity.OrderStatus status) {
    switch (status) {
      case order_entity.OrderStatus.pending:
        return Colors.orange;
      case order_entity.OrderStatus.confirmed:
        return Colors.blue;
      case order_entity.OrderStatus.ready:
        return Colors.green;
      case order_entity.OrderStatus.completed:
        return Colors.purple;
      case order_entity.OrderStatus.cancelled:
        return Colors.red;
    }
  }
}
