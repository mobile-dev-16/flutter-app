import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';
import 'package:eco_bites/features/cart/presentation/widgets/cart_item.dart';

@widgetbook.UseCase(name: 'Default', type: CartItem)
Widget buildCartItemUseCase(BuildContext context) {
  return Center(
    child: CartItem(
      id: '1',
      title: context.knobs.string(
        label: 'Title',
        initialValue: 'Organic Apples',
      ),
      normalPrice:
          context.knobs.double.input(label: 'Normal Price', initialValue: 5.99),
      offerPrice:
          context.knobs.double.input(label: 'Offer Price', initialValue: 4.99),
      quantity: context.knobs.int.slider(
        label: 'Initial Quantity',
        initialValue: 1,
        min: 0,
        max: 10,
        divisions: 10,
      ),
    ),
  );
}
