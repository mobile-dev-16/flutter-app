import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/screens/cart_screen.dart';

@widgetbook.UseCase(name: 'Default', type: CartScreen)
Widget buildCartScreenUseCase(BuildContext context) {
  return BlocProvider<CartBloc>(
    create: (context) => CartBloc([
      CartItemData(
        id: '1',
        title: 'Pineapple Pizza',
        normalPrice: 32000,
        offerPrice: 28000,
      ),
      CartItemData(
        id: '2',
        title: 'Donut',
        normalPrice: 21000,
        offerPrice: 12000,
        quantity: 2,
      ),
      CartItemData(
        id: '3',
        title: 'Chesseburger',
        normalPrice: 15000,
        offerPrice: 12000,
      ),
    ]),
    child: const CartScreen(),
  );
}
