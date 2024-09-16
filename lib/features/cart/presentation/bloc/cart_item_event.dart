import 'package:equatable/equatable.dart';

enum QuantityChangeType { increase, decrease }

abstract class CartItemEvent extends Equatable {
  const CartItemEvent();

  @override
  List<Object> get props => <Object>[];
}

class QuantityChanged extends CartItemEvent {
  const QuantityChanged(this.changeType);
  final QuantityChangeType changeType;
}
