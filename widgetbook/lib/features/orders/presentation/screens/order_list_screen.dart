import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/orders/presentation/screens/order_list_screen.dart';

@widgetbook.UseCase(name: 'Default', type: OrderListScreen)
Widget buildOrderListScreenUseCase(BuildContext context) {
  return const OrderListScreen();
}