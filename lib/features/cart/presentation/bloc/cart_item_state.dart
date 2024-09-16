import 'package:equatable/equatable.dart';

class CartItemState extends Equatable {
  const CartItemState({required this.quantity});

  final int quantity;

  @override
  List<Object> get props => <Object>[quantity];
}
