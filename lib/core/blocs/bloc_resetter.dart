import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:eco_bites/features/auth/presentation/bloc/auth_state.dart';
import 'package:eco_bites/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlocResetter extends StatelessWidget {
  const BlocResetter({
    super.key,
    required this.child,
    this.resetCondition = true,
  });

  final Widget child;
  final bool resetCondition;

  void _resetBlocs(BuildContext context) {
    if (resetCondition) {
      context.read<AddressBloc>().reset();
      context.read<CartBloc>().reset();
      context.read<OrderBloc>().reset();
      context.read<ProfileBloc>().reset();
      context.read<FoodBusinessBloc>().reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<AuthBloc, AuthState>(
          listener: (BuildContext context, AuthState state) {
            if (state is AuthUnauthenticated) {
              _resetBlocs(context);
            }
          },
        ),
      ],
      child: child,
    );
  }
}
