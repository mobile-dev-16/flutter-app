import 'package:eco_bites/features/food/domain/models/cuisine_type.dart';
import 'package:equatable/equatable.dart';

abstract class FoodBusinessEvent extends Equatable {
  const FoodBusinessEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class FetchSurplusFoodBusinesses extends FoodBusinessEvent {
  const FetchSurplusFoodBusinesses({required this.favoriteCuisine});
  final CuisineType favoriteCuisine;

  @override
  List<Object?> get props => <Object?>[favoriteCuisine];
}
