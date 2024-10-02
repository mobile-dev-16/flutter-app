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
      desiredAccuracy: LocationAccuracy.high,
    );

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
      appBar: const CustomAppBar(
          title: 'Choose your address', showBackButton: true),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(4.7110, -74.0721),
              zoom: 14,
            ),
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            markers:
                selectedMarker != null ? <Marker>{selectedMarker!} : <Marker>{},
            onTap: (LatLng position) {
              setState(() {
                selectedPosition = position;
                selectedMarker = Marker(
                  markerId: const MarkerId('selected-location'),
                  position: position,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                );
                _fetchAddress(); // Fetch address when a new location is tapped
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false, // Disable default button
            zoomControlsEnabled: false, // Hide zoom controls
            mapToolbarEnabled: false,
            compassEnabled: false,
            trafficEnabled: false,
            indoorViewEnabled: false,
          ),
          Positioned(
            right: 16,
            bottom: 200, // Adjusted to be above the bottom sheet
            child: FloatingActionButton(
              onPressed: _onMyLocationButtonPressed,
              child: const Icon(Icons.my_location),
            ),
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Text(
              selectedAddress,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: selectedPosition != null
                  ? () {
                      Navigator.pop(context, selectedAddress);
                    }
                  : null,
              child: const Text('Confirm Address'),
            ),
          ],
        ),
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

  // Add this new method
  void _onMyLocationButtonPressed() async {
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    final LatLng userPosition = LatLng(position.latitude, position.longitude);

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(userPosition, 14),
    );

    setState(() {
      selectedPosition = userPosition;
      selectedMarker = Marker(
        markerId: const MarkerId('user-location'),
        position: userPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      );
    });

    _fetchAddress();
  }
}
