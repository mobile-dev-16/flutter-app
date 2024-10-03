import 'package:eco_bites/features/address/domain/models/address.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:eco_bites/features/food/domain/models/food_business.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_event.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_state.dart';
import 'package:eco_bites/features/food/repository/food_business_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FoodBusinessBloc extends Bloc<FoodBusinessEvent, FoodBusinessState> {
  FoodBusinessBloc({
    required this.foodBusinessRepository,
    required this.addressBloc,
  }) : super(FoodBusinessInitial()) {
    on<FetchSurplusFoodBusinesses>(_onFetchSurplusFoodBusinesses);
  }
  final FoodBusinessRepository foodBusinessRepository;
  final AddressBloc addressBloc;

  Future<void> _onFetchSurplusFoodBusinesses(
    FetchSurplusFoodBusinesses event,
    Emitter<FoodBusinessState> emit,
  ) async {
    emit(FoodBusinessLoading());

    try {
      final AddressState addressState = addressBloc.state;

      if (addressState is AddressLoaded) {
        final Address userLocation = addressState.savedAddress;

        final List<FoodBusiness> foodBusinesses =
            await foodBusinessRepository.fetchNearbySurplusFoodBusinesses(
          userLocation: userLocation,
          favoriteCuisine: event.favoriteCuisine,
        );

        emit(FoodBusinessLoaded(foodBusinesses: foodBusinesses));
      } else {
        emit(
          const FoodBusinessError(
              message: 'User address not available. Please set your address.'),
        );
      }
    } catch (e) {
      emit(FoodBusinessError(message: e.toString()));
    }
  }
}
