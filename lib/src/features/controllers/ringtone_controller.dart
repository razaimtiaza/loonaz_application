import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:loonaz_application/src/features/models/ringtones/ringone_model.dart';

import '../apis/ringtone_api/ringtone_api.dart';

class RingtoneScreenController extends GetxController {
  static RingtoneScreenController get find => Get.find();
  final AudioPlayer audioPlayer = AudioPlayer();
  RxString currentPlayingUrl = "".obs;
  RxBool isPlaying = false.obs;

  RxBool isLoading = true.obs;
  RxList<RingtoneModelClass> itemList = <RingtoneModelClass>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDataFromApi();
  }

  Future<void> fetchDataFromApi() async {
    try {
      isLoading.value = true;
      RingtoneApiService ringtoneApiService = RingtoneApiService();
      itemList.value = await ringtoneApiService.getRingtoneFromServer();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void pauseSong() {
    audioPlayer.pause();
    //audioPlayer.resume();
  }

  Future<void> playMusic(String audioUrl) async {
    print("data===1" +
        audioUrl.toString() +
        "  current playing " +
        currentPlayingUrl.value.toString() +
        "isplaying" +
        isPlaying.value.toString());
    try {
      if (audioUrl == currentPlayingUrl.value && isPlaying.value) {
        print("data===2");
        await audioPlayer.pause();
        isPlaying.value = false;
      } else {
        print("data===4");
        await audioPlayer.play(UrlSource(audioUrl));
        currentPlayingUrl.value = audioUrl;
        isPlaying.value = true;
      }
    } catch (e) {}
  }

  void nextScreen() {}
}
