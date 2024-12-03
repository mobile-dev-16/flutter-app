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

class DietaryTab extends StatelessWidget {
  const DietaryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddressBloc, AddressState>(
      listenWhen: (AddressState previous, AddressState current) =>
          previous is! AddressLoaded && current is AddressLoaded,
      listener: (BuildContext context, AddressState addressState) {
        if (addressState is AddressLoaded) {
          final ProfileState profileState = context.read<ProfileBloc>().state;
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
      child: BlocBuilder<FoodBusinessBloc, FoodBusinessState>(
        buildWhen: (FoodBusinessState previous, FoodBusinessState current) =>
            previous.runtimeType != current.runtimeType ||
            (current is FoodBusinessLoaded &&
                previous is FoodBusinessLoaded &&
                current.foodBusinesses != previous.foodBusinesses),
        builder: (BuildContext context, FoodBusinessState state) {
          if (state is FoodBusinessLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FoodBusinessLoaded) {
            final ProfileState profileState = context.read<ProfileBloc>().state;
            final DietType? dietType = profileState is ProfileLoaded
                ? profileState.profile.dietType
                : null;

            final List<FoodBusinessModel> businessesWithDietaryOffers =
                _filterBusinessesWithDietaryOffers(
              state.foodBusinesses,
              dietType,
            );

            if (businessesWithDietaryOffers.isEmpty) {
              return _buildEmptyState(context, dietType);
            }

            return Column(
              children: <Widget>[
                _buildRefreshButton(context, dietType),
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
                        key: ValueKey<String>('${foodBusiness.id}-$dietType'),
                        leading: _buildBusinessAvatar(foodBusiness),
                        title: Text(foodBusiness.name),
                        subtitle: Text(
                          'Suitable for ${dietType?.displayName ?? 'your diet'}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        children: dietaryOffers
                            .map(
                              (Offer offer) => OfferCard(
                                key: ValueKey<String>(
                                  '${offer.id}-${offer.suitableFor.first}',
                                ),
                                offer: offer,
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is FoodBusinessError) {
            return _buildErrorState(context, state);
          }
          return const Center(child: Text('No offers available'));
        },
      ),
    );
  }

  List<FoodBusinessModel> _filterBusinessesWithDietaryOffers(
    List<FoodBusinessModel> businesses,
    DietType? dietType,
  ) {
    return businesses.where((FoodBusinessModel business) {
      return business.offers
          .any((Offer offer) => offer.suitableFor.contains(dietType));
    }).toList();
  }

  Widget _buildBusinessAvatar(FoodBusinessModel business) {
    return CircleAvatar(
      backgroundImage:
          business.imageUrl != null ? NetworkImage(business.imageUrl!) : null,
      child: business.imageUrl == null ? Text(business.name[0]) : null,
    );
  }

  Widget _buildEmptyState(BuildContext context, DietType? dietType) {
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

  Widget _buildRefreshButton(BuildContext context, DietType? dietType) {
    return TextButton(
      onPressed: () {
        final AddressState addressState = context.read<AddressBloc>().state;
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
    );
  }

  Widget _buildErrorState(BuildContext context, FoodBusinessError state) {
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
}
