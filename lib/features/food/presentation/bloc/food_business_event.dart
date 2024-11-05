import 'package:eco_bites/features/address/domain/entities/address.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:eco_bites/features/food/domain/entities/diet_type.dart';
import 'package:equatable/equatable.dart';

abstract class FoodBusinessEvent extends Equatable {
  const FoodBusinessEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class FetchSurplusFoodBusinesses extends FoodBusinessEvent {
  const FetchSurplusFoodBusinesses({
    this.favoriteCuisine,
    this.dietType,
    required this.userLocation,
  });
  final CuisineType? favoriteCuisine;
  final DietType? dietType;
  final Address userLocation;

  @override
  List<Object?> get props => <Object?>[favoriteCuisine, dietType, userLocation];
}
