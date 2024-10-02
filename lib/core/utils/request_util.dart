// ignore_for_file: always_specify_types, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

class RequestUtil {
  static Future<dynamic> getRequest(String url) async {
    try {
      // Convert the URL string into a Uri object
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final String jsonData = response.body;
        final decodeData = jsonDecode(jsonData);
        return decodeData;
      } else {
        print('Failed with status code: ${response.statusCode}');
        return 'Failed';
      }
    } catch (exp) {
      print('Exception caught: $exp');
      return 'Failed';
    }
  }
}
