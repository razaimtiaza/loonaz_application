import 'package:loonaz_application/src/features/apis/dps_api/dps_api.dart';
import 'package:loonaz_application/src/features/models/dps_model/dps_model.dart';

class Dpsmodel {
  final dps = dpsController();
  Future<GpsWallpaper> fetchdpsData() async {
    final resp = dps.fetchdpsData();
    return resp;
  }
}
