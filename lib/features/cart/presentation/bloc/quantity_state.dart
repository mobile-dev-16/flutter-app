import 'package:equatable/equatable.dart';

class QuantityState extends Equatable {
  const QuantityState({required this.value});
  final int value;

  @override
  List<Object> get props => <Object>[value];
}
