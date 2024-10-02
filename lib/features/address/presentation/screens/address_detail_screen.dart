import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressDetailsScreen extends StatefulWidget {
  const AddressDetailsScreen({super.key, required this.position});

  final LatLng position;

  @override
  AddressDetailsScreenState createState() => AddressDetailsScreenState();
}

class AddressDetailsScreenState extends State<AddressDetailsScreen> {
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _buildingTypeController = TextEditingController();
  final TextEditingController _apartmentController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Address Details', showBackButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Selected Location: Lat: ${widget.position.latitude}, Lng: ${widget.position.longitude}'),
            const SizedBox(height: 16),
            TextField(
              controller: _streetController,
              decoration: const InputDecoration(labelText: 'Street'),
            ),
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
            ),
            TextField(
              controller: _buildingTypeController,
              decoration: const InputDecoration(labelText: 'Building Type'),
            ),
            TextField(
              controller: _apartmentController,
              decoration: const InputDecoration(labelText: 'Apartment Name'),
            ),
            TextField(
              controller: _floorController,
              decoration: const InputDecoration(labelText: 'Floor/Unit/Room'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _streetController.text);
              },
              child: const Text('Save Address'),
            ),
          ],
        ),
      ),
    );
  }
}
