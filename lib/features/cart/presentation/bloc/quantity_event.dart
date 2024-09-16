import 'package:equatable/equatable.dart';

abstract class QuantityEvent extends Equatable {
  const QuantityEvent();

  @override
  List<Object> get props => <Object>[];
}

class QuantityIncreased extends QuantityEvent {}

class QuantityDecreased extends QuantityEvent {}
