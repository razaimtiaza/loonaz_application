import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:loonaz_application/src/constants/colors.dart';
import 'package:loonaz_application/src/features/models/ringtones/ringone_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../../constants/sizes.dart';
import 'package:share/share.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RingtoneDetailScreen extends StatefulWidget {
  final List<RingtoneModelClass> itemList;
  final int initialIndex;
  const RingtoneDetailScreen({
    super.key,
    required this.itemList,
    required this.initialIndex,
  });

  @override
  State<RingtoneDetailScreen> createState() => _nameState();
}

// ignore: camel_case_types
class _nameState extends State<RingtoneDetailScreen> {
  late final RingtoneModelClass ringtoneModel;
  final AudioPlayer audioPlayer = AudioPlayer();
  String currentPlayingUrl = "";
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    ringtoneModel = widget.itemList[widget.initialIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          elevation: 0,
          title: Row(
            children: [
              Icon(
                Icons.person_2_rounded,
                color: Colors.white.withOpacity(0.7),
                size: 30.0,
              ),
              const SizedBox(
                width: 5.0,
              ),
              const Text("byt119718")
            ],
          ),
        ),
        body: PageView.builder(
            itemCount: widget.itemList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.lightGreen,
                          Colors.blueGrey
                        ], // Replace with your desired colors
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius:
                          BorderRadius.all(Radius.circular(defaultPadding / 2)),
                    ),
                    child: Column(children: [
                      const SizedBox(
                        height: tDefaultSize * 3,
                      ),
                      Text(
                        ringtoneModel.title,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: tDefaultSize / 4,
                      ),
                      Stack(
                        children: [
                          Container(
                            width: 240,
                            height: 240,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.lightGreen,
                                  Colors.blueGrey
                                ], // Replace with your desired colors
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.all(
                                  Radius.circular(defaultPadding / 2)),
                            ),
                          ),
                          // GestureDetector(
                          //   onTap: () {
                          //     toggleAudioPlayback(ringtoneModel.audioUrl);
                          //     playMusic(ringtoneModel.audioUrl);
                          //   },
                          //   child: SizedBox(
                          //     width: 240,
                          //     height: 240,
                          //     child: Icon(
                          //       isPlaying
                          //           ? Icons.pause_circle_filled
                          //           : Icons.play_circle_fill_outlined,
                          //       color: Colors.white.withOpacity(0.7),
                          //       size: 84.0,
                          //     ),
                          //   ),
                          // )
                          Padding(
                            padding: const EdgeInsets.all(88.0),
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (isPlaying) {
                                    // Stop the ringtone here
                                    // You should implement the logic to stop the ringtone
                                    _playMusic1(ringtoneModel.audioUrl);
                                  } else {
                                    // Start the ringtone here
                                    // You should implement the logic to start the ringtone
                                    _playMusic1(ringtoneModel.audioUrl);
                                  }
                                  isPlaying = !isPlaying; // Toggle the state
                                });
                              },
                              icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: tDefaultSize / 4,
                      ),
                      Text(
                        "${ringtoneModel.duration} sec",
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12.0,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: tDefaultSize * 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              String linkToShare = ringtoneModel
                                  .audioUrl; // Replace with your link
                              //  print("data==");
                              shareLink(linkToShare);
                            },
                            icon: const Icon(Icons.share,
                                size: 25, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return BottomPopUpContent(
                                      ringtoneModel: ringtoneModel);
                                },
                              );
                            },
                            icon: const Icon(Icons.arrow_downward,
                                size: 25, color: Colors.white),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.favorite_border,
                                size: 25, color: Colors.white),
                          ),
                        ],
                      )
                    ]),
                  )
                ],
              );
            }));
  }

  void shareLink(String link) {
    try {
      Share.share(link);
    } catch (e) {
      print('data===: $e');
    }
  }

  Future<void> _playMusic1(String audioUrl) async {
    print("data===1$audioUrl");
    try {
      if (audioUrl == currentPlayingUrl && isPlaying) {
        print("data===2");
        await audioPlayer.pause();
        setState(() {
          print("data===3");
          isPlaying = false;
        });
      } else {
        print("data===4");
        await audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          print("data===5");
          currentPlayingUrl = audioUrl;
          isPlaying = true;
        });
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  Future<void> toggleAudioPlayback(String audioUrl) async {
    if (audioUrl == currentPlayingUrl && isPlaying) {
      await audioPlayer.pause();
      isPlaying = false;
    } else {
      await audioPlayer.play(UrlSource(audioUrl));
      currentPlayingUrl = audioUrl;
      isPlaying = true;
    }
  }

  void saveSelectedRingtone(String ringtoneUri) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('defaultRingtone', ringtoneUri);
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

class DefaultNotificationSoundPage {
  static const platform = MethodChannel('default_notification_sound');

  void setDefaultNotificationSound(String ringtoneUri) async {
    try {
      await platform.invokeMethod(
          'setDefaultNotificationSound', {'ringtoneUri': ringtoneUri});
    } on PlatformException catch (e) {
      print('Failed to set default notification sound: ${e.message}');
    }
  }
}

class BottomPopUpContent extends StatelessWidget {
  final RingtoneModelClass ringtoneModel; // Add thi
  const BottomPopUpContent({super.key, required this.ringtoneModel}); //
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: () {
              _setNotification(context);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.notifications,
                  size: 22,
                  color: tWhiteColor,
                ),
                SizedBox(width: 16.0),
                Text(
                  'SET NOTIFICATION',
                  style: TextStyle(color: tWhiteColor, fontSize: 12.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              _setCallRingtone(context);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.volume_up,
                  size: 22,
                  color: tWhiteColor,
                ),
                SizedBox(width: 16.0),
                Text(
                  'SET RINGTONE',
                  style: TextStyle(color: tWhiteColor, fontSize: 12.0),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          GestureDetector(
            onTap: () {
              // downloadMP3File(rin, "filename");
              _saveToMediaFolder(context, ringtoneModel);
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                Icon(
                  Icons.volume_up,
                  size: 22,
                  color: tWhiteColor,
                ),
                SizedBox(width: 16.0),
                Text(
                  'SAVE TO MEDIA FOLDER',
                  style: TextStyle(color: tWhiteColor, fontSize: 12.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black45,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> _setNotification(BuildContext context) async {
    try {
      // Logic to set the ringtone as a notification sound
      DefaultNotificationSoundPage()
          .setDefaultNotificationSound(ringtoneModel.audioUrl);
      _showSnackbar("Ringtone set as notification sound");
    } catch (e) {
      _showSnackbar("Failed to set notification sound");
    }
  }

  void _showSnackbar(String message) {
    Get.snackbar(
      'Notification',
      message,
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.black54,
      colorText: Colors.white,
    );
  }

  Future<void> _setCallRingtone(BuildContext context) async {
    PermissionStatus status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      try {
        // Logic to set the ringtone as a call ringtone
        DefaultCallRingtonePage().setCallRingtone(ringtoneModel.audioUrl);
        _showSnackbar("Ringtone set as call ringtone");
      } catch (e) {
        _showSnackbar("Failed to set call ringtone");
      }
    } else if (status.isDenied) {
      // Show a dialog or message to inform the user about the denied permission
      _showPermissionDeniedDialog(context);
    }
  }

  Future<void> _saveToMediaFolder(
    BuildContext context,
    RingtoneModelClass ringtoneModel,
  ) async {
    PermissionStatus status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        await downloadAndSaveRingtone(ringtoneModel.audioUrl);
        Get.snackbar(
          'Notification',
          "Ringtone Saved to media",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
      } catch (e) {
        Get.snackbar(
          'Notification',
          "Failed to save",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.black54,
          colorText: Colors.white,
        );
      }
    } else if (status.isDenied) {
      // Show a dialog or message to inform the user about the denied permission
      _showPermissionDeniedDialog(context);
    }
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Denied"),
          content: const Text(
              "Please grant storage permission to download and save the ringtone."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadAndSaveRingtone(String url) async {
    Random random = Random();
    int number = random.nextInt(10);
    String fileName = "ringtone$number.mp3";

    final request = await http.get(Uri.parse(url));
    if (request.statusCode == 200) {
      var bytes = request.bodyBytes;
      var dir =
          await getExternalStorageDirectory(); // Use getExternalStorageDirectory() for saving to external storage
      File file = File('${dir!.path}/$fileName');

      await file.writeAsBytes(bytes);
    } else {
      throw Exception("Failed to download ringtone");
    }
  }
}

class DefaultCallRingtonePage {
  static const platform = MethodChannel('default_call_ringtone');

  void setCallRingtone(String ringtoneUri) async {
    try {
      await platform
          .invokeMethod('setCallRingtone', {'ringtoneUri': ringtoneUri});
    } on PlatformException catch (e) {
      print('Failed to set call ringtone: ${e.message}');
    }
  }
}
