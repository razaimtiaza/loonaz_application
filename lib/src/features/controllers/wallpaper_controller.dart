import 'package:get/get.dart';
import 'package:loonaz_application/src/features/apis/wallpaper_api/ringtone_api.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';

class WallpaperController extends GetxController {
  static WallpaperController get find => Get.find();
  RxList<WallpaperModelClass> itemList = <WallpaperModelClass>[].obs;
  RxBool isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      isLoading.value = true;
      WallpaperApiService wallpaperApiService = WallpaperApiService();
      itemList.value = await wallpaperApiService.getWallpaperFromServer();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
