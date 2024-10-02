// ignore_for_file: always_specify_types, avoid_dynamic_calls

import 'package:eco_bites/core/utils/request_util.dart';

Future<String?> getAddressFromLatLng(double lat, double lng, String apiKey) async {
  String placeAddress = '';
  final String url = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

  final response = await RequestUtil.getRequest(url);

  // Debugging: print the response to the console for inspection
  if (response != 'Failed') {
    if (response['results'] != null && response['results'].isNotEmpty) {
      placeAddress = response['results'][0]['formatted_address'];
    } else {
      print('No address found in the response. Full response: $response');
      placeAddress = 'No address found for this location';
    }
  } else {
    placeAddress = 'Failed to fetch address';
  }

  return placeAddress;
}
