import 'package:eco_bites/features/food/domain/models/food_business.dart';
import 'package:eco_bites/features/food/domain/models/offer.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_bloc.dart';
import 'package:eco_bites/features/food/presentation/bloc/food_business_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForYouTab extends StatelessWidget {
  const ForYouTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodBusinessBloc, FoodBusinessState>(
      builder: (BuildContext context, FoodBusinessState state) {
        if (state is FoodBusinessLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodBusinessLoaded) {
          return ListView.builder(
            itemCount: state.foodBusinesses.length,
            itemBuilder: (BuildContext context, int index) {
              final FoodBusiness foodBusiness = state.foodBusinesses[index];
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
                children: foodBusiness.offers
                    .map((Offer offer) => OfferCard(offer: offer))
                    .toList(),
              );
            },
          );
        } else if (state is FoodBusinessError) {
          return Center(child: Text(state.message));
        }
        return const Center(child: Text('No offers available'));
      },
    );
  }
}

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer});
  final Offer offer;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: offer.imageUrl != null
            ? Image.network(
                offer.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
            : const Icon(Icons.fastfood),
        title: Text(offer.description),
        subtitle: Text(
          '${offer.offerPrice.toStringAsFixed(2)} (was ${offer.normalPrice.toStringAsFixed(2)})',
        ),
        trailing: ElevatedButton(
          child: const Text('Add to Cart'),
          onPressed: () {
            // TODO(abel): Implement add to cart functionality
            // You can use the offer.toCartItem() method here
          },
        ),
      ),
    );
  }
}
