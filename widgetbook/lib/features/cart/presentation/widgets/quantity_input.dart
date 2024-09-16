import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:eco_bites/features/cart/presentation/widgets/quantity_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_bloc.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_item_event.dart';

@widgetbook.UseCase(name: 'Default', type: QuantityInput)
Widget buildQuantityInputUseCase(BuildContext context) {
  return BlocProvider(
    create: (context) => CartItemBloc(1),
    child: Builder(
      builder: (context) {
        return Center(
          child: QuantityInput(
            onIncrease: () {
              context.read<CartItemBloc>().add(
                    const QuantityChanged(QuantityChangeType.increase),
                  );
            },
            onDecrease: () {
              context.read<CartItemBloc>().add(
                    const QuantityChanged(QuantityChangeType.decrease),
                  );
            },
          ),
        );
      },
    ),
  );
}
