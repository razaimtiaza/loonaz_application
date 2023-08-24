import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:loonaz_application/src/features/models/live_wallaper/live_model.dart';

class LiveController {
  Future<Livewallpaper> fetchData() async {
    String Url =
        "https://loonaz.com/api/list/?port=video&page=3&per_page=10&query=new";
    final response = await http.get(Uri.parse(Url));
    // print(response.body);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Livewallpaper.fromJson(body);
    }
    throw "Error";
  }
}
