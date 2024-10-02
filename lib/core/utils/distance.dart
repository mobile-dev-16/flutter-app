import 'dart:math';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double p = 0.017453292519943295;
  final double a = 0.5 -
      cos((lat2 - lat1) * p) / 2 +
      cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a)); // 2 * R; R = 6371 km
}

bool isFarFromSavedAddress(
  double currentLat,
  double currentLon,
  double savedLat,
  double savedLon, {
  double threshold = 1.0,
}) {
  final double distance =
      calculateDistance(currentLat, currentLon, savedLat, savedLon);
  return distance > threshold;
}
