import 'package:eco_bites/app.dart';
import 'package:eco_bites/features/auth/presentation/bloc/login_bloc.dart';
import 'package:eco_bites/features/auth/repository/auth_repository.dart';
import 'package:eco_bites/features/cart/domain/models/cart_item_data.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart';

void main() {
  final AuthRepository authRepository =
      AuthRepository(); // Mock or actual implementation

  runApp(
    MultiBlocProvider(
      providers: <SingleChildWidget>[
        BlocProvider<CartBloc>(
          create: (BuildContext context) => CartBloc(<CartItemData>[
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
              offerPrice: 11000,
              quantity: 2,
            ),
            CartItemData(
              id: '3',
              title: 'Cheeseburger',
              normalPrice: 15000,
              offerPrice: 12000,
            ),
          ]),
        ),
        BlocProvider<LoginBloc>(
          create: (BuildContext context) =>
              LoginBloc(authRepository: authRepository),
        ),
        BlocProvider<OrderBloc>(
          create: (BuildContext context) => OrderBloc()..add(LoadOrders()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
