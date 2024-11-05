import 'package:eco_bites/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(StorageKeys.userId);
}
