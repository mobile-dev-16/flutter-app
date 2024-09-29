import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';
import 'package:eco_bites/features/orders/domain/models/order.dart';
import 'package:eco_bites/features/orders/presentation/widgets/order_item.dart';

@widgetbook.UseCase(name: 'Default', type: OrderItem)
Widget buildOrderItemUseCase(BuildContext context) {
  return Center(
    child: OrderItem(
      order: Order(
        id: '1',
        title: context.knobs.string(
          label: 'Title',
          initialValue: 'Order #12345',
        ),
        date: DateTime.now().subtract(
          Duration(days: context.knobs.int.slider(
            label: 'Days Ago',
            initialValue: 5,
            min: 0,
            max: 30,
          )),
        ),
      ),
    ),
  );
}
