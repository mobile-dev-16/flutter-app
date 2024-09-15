import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:eco_bites/features/cart/presentation/screens/cart_screen.dart';

@widgetbook.UseCase(name: 'Default', type: CartScreen)
Widget buildCartScreenUseCase(BuildContext context) {
  return const CartScreen();
}
