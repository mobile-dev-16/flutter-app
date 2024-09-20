import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class LoadOrders extends OrderEvent {}
