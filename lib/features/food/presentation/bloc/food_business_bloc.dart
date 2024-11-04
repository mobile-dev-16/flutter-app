import 'package:dartz/dartz.dart';
import 'package:eco_bites/core/blocs/resettable_mixin.dart';
import 'package:eco_bites/core/error/failures.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/domain/entities/food_business.dart';
import 'package:eco_bites/features/food/domain/usecases/fetch_nearby_surplus_food_businesses.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_event.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class FoodBusinessBloc extends Bloc<FoodBusinessEvent, FoodBusinessState>
    with ResettableMixin<FoodBusinessEvent, FoodBusinessState> {
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

    result.fold(
      (Failure failure) {
        Logger().e('Failed to fetch food businesses: ${failure.message}');
        emit(FoodBusinessError(message: failure.message));
      },
      (List<FoodBusiness> businesses) {
        Logger().d('Number of businesses fetched: ${businesses.length}');
        for (var business in businesses) {
          Logger().d('Fetched business: ${business.name}');
        }

        emit(FoodBusinessLoaded(
          foodBusinesses: businesses
              .map((FoodBusiness business) =>
                  FoodBusinessModel.fromEntity(business))
              .toList(),
        ));
      },
    );
  }

  @override
  void reset() {
    // ignore: invalid_use_of_visible_for_testing_member
    emit(FoodBusinessInitial());
  }
}
