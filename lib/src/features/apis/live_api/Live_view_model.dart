import 'package:loonaz_application/src/features/apis/live_api/live_wallaper.dart';
import 'package:loonaz_application/src/features/models/live_wallaper/live_model.dart';

class Livemodel {
  final live = LiveController();
  Future<Livewallpaper> fetchData() async {
    final resp = live.fetchData();
    return resp;
  }
}
