import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eco_bites/core/ui/layouts/main_layout.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';

@widgetbook.UseCase(name: 'Home', type: MainLayout)
Widget buildMainLayoutUseCase(BuildContext context) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<CartBloc>(
        create: (context) => CartBloc([]),
      ),
    ],
    child: MainLayout(appLaunchTime: DateTime.now()),
  );
}
