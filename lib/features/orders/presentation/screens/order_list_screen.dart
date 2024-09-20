import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/features/orders/domain/models/order.dart'; // Asegúrate de importar el modelo de order
import 'package:eco_bites/features/orders/presentation/bloc/order_bloc.dart';
import 'package:eco_bites/features/orders/presentation/bloc/order_state.dart';
import 'package:eco_bites/features/orders/presentation/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const OrderListScreenContent();
  }
}

class OrderListScreenContent extends StatelessWidget {
  const OrderListScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Orders'),
      body: BlocBuilder<OrderBloc, OrderState>(
        builder: (BuildContext context, OrderState state) {
          if (state is OrdersLoading) {
            return const Center(child: CircularProgressIndicator()); // Indicador de carga
          } else if (state is OrdersLoaded) {
            if (state.orders.isEmpty) {
              return const Center(child: Text('No orders available')); // Manejo del estado vacío
            }
            return ListView.builder(
              itemCount: state.orders.length,
              itemBuilder: (BuildContext context, int index) {
                final Order order = state.orders[index];
                return OrderItem(order: order);
              },
            );
          } else {
            return const Center(child: Text('Failed to load orders')); // Manejo de errores
          }
        },
      ),
    );
  }
}
