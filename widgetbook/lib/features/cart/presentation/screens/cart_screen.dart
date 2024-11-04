import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/screens/cart_screen.dart';

@widgetbook.UseCase(name: 'Default', type: CartScreen)
Widget buildCartScreenUseCase(BuildContext context) {
  return BlocProvider<CartBloc>(
    create: (context) => CartBloc([]),
    child: const CartScreen(),
  );
}
