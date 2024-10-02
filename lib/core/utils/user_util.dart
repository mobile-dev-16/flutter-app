import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserId() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userId');
}
