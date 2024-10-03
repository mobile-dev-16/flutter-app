import 'package:eco_bites/features/food/domain/models/food_business.dart';
import 'package:equatable/equatable.dart';

abstract class FoodBusinessState extends Equatable {
  const FoodBusinessState();

  @override
  List<Object?> get props => <Object?>[];
}

class FoodBusinessInitial extends FoodBusinessState {}

class FoodBusinessLoading extends FoodBusinessState {}

class FoodBusinessLoaded extends FoodBusinessState {
  const FoodBusinessLoaded({required this.foodBusinesses});
  final List<FoodBusiness> foodBusinesses;

  @override
  List<Object?> get props => <Object?>[foodBusinesses];
}

class FoodBusinessError extends FoodBusinessState {
  const FoodBusinessError({required this.message});
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
