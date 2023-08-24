import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loonaz_application/src/features/models/pfps_model/pfps_model.dart';

class pfpsController {
  Future<pfpsWallpaper> fetchdpfpsData() async {
    String url =
        "https://loonaz.com/api/list/?port=pfp&page=3&per_page=10&query=new";
    try {
      final response = await http.get(Uri.parse(url));

      print("API Response Code: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return pfpsWallpaper.fromJson(body);
      } else {
        throw Exception(
            "API request failed with status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching data: $error");
      throw Exception("Error fetching data: $error");
    }
  }
}
