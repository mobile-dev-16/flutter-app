import 'package:equatable/equatable.dart';
abstract class OrderEvent extends Equatable {
  @override
  List<Object?> get props;
}
class LoadOrders extends OrderEvent {
  @override
  List<Object?> get props => <Object?>[];
}
