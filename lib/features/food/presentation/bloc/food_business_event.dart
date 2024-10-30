import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/food/domain/entities/cuisine_type.dart';
import 'package:equatable/equatable.dart';

abstract class FoodBusinessEvent extends Equatable {
  const FoodBusinessEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class FetchSurplusFoodBusinesses extends FoodBusinessEvent {
  const FetchSurplusFoodBusinesses({
    required this.favoriteCuisine,
    required this.userLocation,
  });
  final CuisineType favoriteCuisine;
  final Address userLocation;

  @override
  List<Object?> get props => <Object?>[favoriteCuisine];
}
