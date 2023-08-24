// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';
import 'package:loonaz_application/src/features/models/ringtones/ringone_model.dart';
import 'package:http/http.dart' as http;

class WallpaperApiService {
  Future<List<RingtoneModelClass>> getRingtoneFromServer1() async {
    final response = await http.get(Uri.parse(
        'https://loonaz.com/api/list/?port=ringtone&page=3&per_page=10&query=new'));

    if (kDebugMode) {
      print("data== for  ${response.body}");
    }

    if (response.statusCode == 200) {
      // print("data== for  "+response.toString());
      // List<dynamic> jsonResponse = jsonDecode(response.body);
      var data = json.decode(response.body)['data'][0];
      if (kDebugMode) {
        print("data== for  " + data[0]);
      }
      //  print("data== for  "+data['data']["title"]);

      List<RingtoneModelClass> list = [];
      if (/*data["status"] == '1' */ true) {
        //  print("=======fsfsf========= inside if =="+response.body);
        // for(int i = 0; i < data["response1"].length; i++)
        for (int i = 0; i < data["data"].length; i++) {
          print("data== for ${data["data"].length}");
          print("data== for " + data["data"][i]["id"]);
          print("data== for " + data["data"][i]["title"]);
          RingtoneModelClass ob = RingtoneModelClass(
            id: data["data"][i]["id"],
            title: data["data"][i]["title"],
            duration: data["data"][i]["duration"],
            catname: data["data"][i]["catname"],
            audioUrl: data["data"][i]["file_mp3"],
          );
          //   Photo photo = Photo(title: "sfsffs", url: "ljljljl");
          list.add(ob);
        }
        // print("=======fsfsf========= for "+ categoryList.length.toString());
      }

      return list;
    } else {
      throw Exception('Failed to load persons from server');
    }
  }

  Future<List<WallpaperModelClass>> getWallpaperFromServer() async {
    final String url =
        'https://loonaz.com/api/list/?port=wallpaper&page=3&per_page=10&query=new'; // Replace with your server URL
    List<WallpaperModelClass> list = [];
    try {
      final http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Request successful, parse the response data as JSON
        List<dynamic> responseData = json.decode(response.body)['data'][0];
        print("data==2 ${responseData.length}");

        for (int i = 0; i < responseData.length; i++) {
          Map<String, dynamic> specificElement =
              Map<String, dynamic>.from(responseData[i]);
          print("data==2 " + specificElement["id"]);
          WallpaperModelClass ob = WallpaperModelClass(
              id: int.parse(specificElement["id"]),
              title: specificElement['title'],
              catname: specificElement['catname'],
              imageUrl: specificElement['file_high']);
          //   Photo photo = Photo(title: "sfsffs", url: "ljljljl");
          list.add(ob);
        }

        // Map<String, dynamic> specificElement = Map<String,dynamic>.from(responseData[1]);
        // print("data==2 "+specificElement['id']);
        // print("data==2 "+responseData.toString());
      } else {
        // Request failed with an error status code
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Request failed with an exception
      print('Error: $e');
    }
    return list;
  }
}
