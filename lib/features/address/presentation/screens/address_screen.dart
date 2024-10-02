import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/core/utils/reverse_geocoding.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  AddressScreenState createState() => AddressScreenState();
}

class AddressScreenState extends State<AddressScreen> {
  late GoogleMapController mapController;
  LatLng? selectedPosition;
  String selectedAddress = 'Tap on the map to select a location';
  bool isLoading = false;
  Marker? selectedMarker;

  // Your API Key here
  final String apiKey = 'AIzaSyDeLQq34HhoXDacI5UOJ1VVKbXCT1iStYo';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Choose your address', showBackButton: true),
      body: Column(
        children: <Widget>[
          // The GoogleMap only takes 50% of the screen height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,  // 50% of the screen
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(4.7110, -74.0721),  // Example coordinates (Bogotá)
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: selectedMarker != null ? {selectedMarker!} : {},  // Show the selected marker
                  onTap: (LatLng position) {
                    setState(() {
                      selectedPosition = position;
                      selectedMarker = Marker(
                        markerId: const MarkerId('selected-location'),
                        position: position,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      );
                      _fetchAddress();
                    });
                  },
                ),
                if (isLoading)
                  const Center(child: CircularProgressIndicator()),  // Show loader while fetching address
              ],
            ),
          ),

          // The other 50% of the screen is used to display the address and buttons
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                // Display the geocoded address
                Text(
                  selectedAddress,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                // Confirm address button
                ElevatedButton(
                  onPressed: selectedPosition != null ? () {
                    Navigator.pop(context, selectedAddress);
                  } : null,  // Disable button if no position is selected
                  child: const Text('Confirm Address'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Fetch address function
  Future<void> _fetchAddress() async {
    if (selectedPosition != null) {
      setState(() {
        isLoading = true;
        selectedAddress = 'Fetching address...';
      });

      try {
        // Fetch the address using the latitude and longitude
        final String? address = await getAddressFromLatLng(
          selectedPosition!.latitude,
          selectedPosition!.longitude,
          apiKey,
        );

        setState(() {
          if (address != null && address.isNotEmpty) {
            selectedAddress = address;
          } else {
            selectedAddress = 'Address not found';
          }
        });
      } catch (e) {
        setState(() {
          selectedAddress = 'Failed to fetch address';
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
