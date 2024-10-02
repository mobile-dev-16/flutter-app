// ignore_for_file: deprecated_member_use
import 'package:eco_bites/core/ui/widgets/custom_appbar.dart';
import 'package:eco_bites/core/utils/reverse_geocoding.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // GPS
import 'package:google_maps_flutter/google_maps_flutter.dart'; //GOOGLE MAPS EXTERNAL SERVICE

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
  final String apiKey = 'AIzaSyDeLQq34HhoXDacI5UOJ1VVKbXCT1iStYo';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get user's current location on screen load
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        selectedAddress = 'Location services are disabled.';
      });
      return;
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          selectedAddress = 'Location permissions are denied.';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        selectedAddress = 'Location permissions are permanently denied.';
      });
      return;
    }

    // Get the current position of the user
    final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,);

    final LatLng userPosition = LatLng(position.latitude, position.longitude);

    // Move the map camera to the user's location
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(userPosition, 14),
    );

    // Update the marker and selected position
    setState(() {
      selectedPosition = userPosition;
      selectedMarker = Marker(
        markerId: const MarkerId('user-location'),
        position: userPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
      _fetchAddress(); // Fetch address after locating user
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Choose your address', showBackButton: true),
      body: Column(
        children: <Widget>[
          // The GoogleMap only takes 50% of the screen height
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,  // 50% of the screen
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(4.7110, -74.0721),  // Default to Bogota until GPS fetches location
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    mapController = controller;
                  },
                  markers: selectedMarker != null ? <Marker>{selectedMarker!} : <Marker>{},  // Show the selected marker
                  onTap: (LatLng position) {
                    setState(() {
                      selectedPosition = position;
                      selectedMarker = Marker(
                        markerId: const MarkerId('selected-location'),
                        position: position,
                        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      );
                      _fetchAddress();  // Fetch address when a new location is tapped
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
