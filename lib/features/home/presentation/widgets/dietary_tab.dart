import 'package:eco_bites/features/address/presentation/bloc/address_bloc.dart';
import 'package:eco_bites/features/address/presentation/bloc/address_state.dart';
import 'package:eco_bites/features/food/data/models/food_business_model.dart';
import 'package:eco_bites/features/food/domain/entities/diet_type.dart';
import 'package:eco_bites/features/food/domain/entities/offer.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_bloc.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_event.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_state.dart';
import 'package:eco_bites/features/home/presentation/widgets/for_you_tab.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:eco_bites/features/profile/presentation/bloc/profile_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class DietaryTab extends StatelessWidget {
  const DietaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listener: (BuildContext context, AddressState addressState) {
        if (addressState is AddressLoaded) {
          final ProfileState profileState = context.read<ProfileBloc>().state;
          if (profileState is ProfileLoaded) {
            Logger().d(
              'Fetching dietary offers with diet type: ${profileState.profile.dietType}',
            );
            context.read<FoodBusinessBloc>().add(
                  FetchSurplusFoodBusinesses(
                    userLocation: addressState.savedAddress,
                    dietType: profileState.profile.dietType,
                  ),
                );
          }
        }
      },
      child: BlocBuilder<FoodBusinessBloc, FoodBusinessState>(
        builder: (BuildContext context, FoodBusinessState state) {
          if (state is FoodBusinessLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodBusinessLoaded) {
            final ProfileState profileState = context.read<ProfileBloc>().state;
            final DietType? dietType = profileState is ProfileLoaded
                ? profileState.profile.dietType
                : null;

            Logger().d('Diet type from profile: ${dietType?.name} ');
            Logger().d('Number of businesses: ${state.foodBusinesses.length}');

            // Filter businesses that have offers matching user's diet
            final List<FoodBusinessModel> businessesWithDietaryOffers =
                state.foodBusinesses.where((FoodBusinessModel business) {
              final List<Offer> dietaryOffers = business.offers
                  .where((Offer offer) => offer.suitableFor.contains(dietType))
                  .toList();
              return dietaryOffers.isNotEmpty;
            }).toList();

            Logger().d(
              'all offers: ${state.foodBusinesses.map((FoodBusinessModel e) => e.offers.map((Offer e) => e.suitableFor))}',
            );
            Logger().d(
              'Businesses with dietary offers: ${businessesWithDietaryOffers.length}',
            );

            if (businessesWithDietaryOffers.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No offers available for ${dietType?.displayName ?? 'your diet'}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        final AddressState addressState =
                            context.read<AddressBloc>().state;
                        if (addressState is AddressLoaded) {
                          context.read<FoodBusinessBloc>().add(
                                FetchSurplusFoodBusinesses(
                                  userLocation: addressState.savedAddress,
                                  dietType: dietType,
                                ),
                              );
                        }
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    final AddressState addressState =
                        context.read<AddressBloc>().state;
                    if (addressState is AddressLoaded) {
                      context.read<FoodBusinessBloc>().add(
                            FetchSurplusFoodBusinesses(
                              userLocation: addressState.savedAddress,
                              dietType: dietType,
                            ),
                          );
                    }
                  },
                  child: const Text('Refresh'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: businessesWithDietaryOffers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final FoodBusinessModel foodBusiness =
                          businessesWithDietaryOffers[index];
                      final List<Offer> dietaryOffers = foodBusiness.offers
                          .where(
                            (Offer offer) =>
                                offer.suitableFor.contains(dietType),
                          )
                          .toList();

                      return ExpansionTile(
                        leading: CircleAvatar(
                          backgroundImage: foodBusiness.imageUrl != null
                              ? NetworkImage(foodBusiness.imageUrl!)
                              : null,
                          child: foodBusiness.imageUrl == null
                              ? Text(foodBusiness.name[0])
                              : null,
                        ),
                        title: Text(foodBusiness.name),
                        subtitle: Text(
                          'Suitable for ${dietType?.displayName ?? 'your diet'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        children: dietaryOffers
                            .map<Widget>(
                              (Offer offer) => OfferCard(offer: offer),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FoodBusinessError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(state.message),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      final AddressState addressState =
                          context.read<AddressBloc>().state;
                      if (addressState is AddressLoaded) {
                        final ProfileState profileState =
                            context.read<ProfileBloc>().state;
                        if (profileState is ProfileLoaded) {
                          context.read<FoodBusinessBloc>().add(
                                FetchSurplusFoodBusinesses(
                                  userLocation: addressState.savedAddress,
                                  dietType: profileState.profile.dietType,
                                ),
                              );
                        }
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: Text('No offers available'));
        },
      ),
    );
  }
}
