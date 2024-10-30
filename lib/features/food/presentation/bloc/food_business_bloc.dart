import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/usecases/fetch_nearby_surplus_food_businesses.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_event.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FoodBusinessBloc extends Bloc<FoodBusinessEvent, FoodBusinessState> {
  FoodBusinessBloc({
    required FetchNearbySurplusFoodBusinesses fetchNearbySurplusFoodBusinesses,
  })  : _fetchNearbySurplusFoodBusinesses = fetchNearbySurplusFoodBusinesses,
        super(FoodBusinessInitial()) {
    on<FetchSurplusFoodBusinesses>(_onFetchSurplusFoodBusinesses);
  }

  final FetchNearbySurplusFoodBusinesses _fetchNearbySurplusFoodBusinesses;

  Future<void> _onFetchSurplusFoodBusinesses(
    FetchSurplusFoodBusinesses event,
    Emitter<FoodBusinessState> emit,
  ) async {
    Logger().d('FetchSurplusFoodBusinesses event received');

    emit(FoodBusinessLoading());

    Logger().d('User location: ${event.userLocation}');
    Logger().d('Favorite cuisine: ${event.favoriteCuisine}');

    final Either<Failure, List<FoodBusiness>> result =
        await _fetchNearbySurplusFoodBusinesses(
      FetchNearbySurplusFoodBusinessesParams(
        userLocation: event.userLocation,
        favoriteCuisine: event.favoriteCuisine,
      ),
    );

    Logger().d('Result: $result');
    emit(
      result.fold(
        (Failure failure) => FoodBusinessError(message: failure.message),
        (List<FoodBusiness> businesses) => FoodBusinessLoaded(
          foodBusinesses: businesses
              .map(
                (FoodBusiness business) =>
                    FoodBusinessModel.fromEntity(business),
              )
              .toList(),
        ),
      ),
    );
  }
}
