import 'package:loonaz_application/src/features/apis/pfps/pfps_api.dart';

import 'package:loonaz_application/src/features/models/pfps_model/pfps_model.dart';

class pfpsmodel {
  final dps = pfpsController();
  Future<pfpsWallpaper> fetchpfpsData() async {
    final resp = dps.fetchdpfpsData();
    return resp;
  }
}
