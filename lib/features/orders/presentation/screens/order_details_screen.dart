import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/core/utils/date_utils.dart' as date_utils;
import 'package:eco_bites/features/orders/domain/entities/order.dart'
    as order_entity;
import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  final order_entity.Order order;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order #${order.id.substring(0, 8)}',
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          // Business Info
          Text(
            order.businessName,
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),

          // Order Status
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
              style: theme.textTheme.titleMedium?.copyWith(
                color: _getStatusColor(order.status),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Order Items
          Text(
            'Order Items',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...order.items.map(
            (order_entity.OrderItem item) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.name}',
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Text(
                    'COP ${item.price.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Total',
                style: theme.textTheme.titleLarge,
              ),
              Text(
                'COP ${order.totalAmount.toStringAsFixed(2)}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Order Date
          Text(
            'Ordered on ${date_utils.DateUtils.formatDateTime(order.createdAt)}',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
        ],
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
