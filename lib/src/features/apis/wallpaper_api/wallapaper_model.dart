import 'package:loonaz_application/src/features/apis/wallpaper_api/wallapaper_api.dart';

import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';

class wallmodel {
  final wall = wallapaperControl();
  Future<Wallpaper> fetchwallData() async {
    final resp = wall.fetchwallData();
    return resp;
  }
}
