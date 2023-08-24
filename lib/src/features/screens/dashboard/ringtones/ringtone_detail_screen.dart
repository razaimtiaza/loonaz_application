
import 'dart:io';
import 'dart:math';
import 'package:flutter/services.dart';
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


// ignore: must_be_immutable
class RingtoneDetailScreen extends StatelessWidget {
  RingtoneDetailScreen({Key? key,
   required this.ringtoneModelClass}) : super(key: key);
final RingtoneModelClass ringtoneModelClass;

final AudioPlayer audioPlayer = AudioPlayer();
 String currentPlayingUrl = "";
  bool isPlaying = false;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
          SizedBox(
            width: 5.0,
          ),
          Text("byt119718")
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
             height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.lightGreen, Colors.blueGrey], // Replace with your desired colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding/2)),
            ),
            child: Column(
              children :
              [
                SizedBox(
                  height: tDefaultSize * 3,
                ),
                Text(ringtoneModelClass.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                      color: Colors.white
                  ),
                ),
                SizedBox(
                  height: tDefaultSize/4,
                ),
                Stack(
                  children: [
                    Container(
                      width: 240,
                      height: 240,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightGreen, Colors.blueGrey], // Replace with your desired colors
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(defaultPadding/2)),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        playMusic(ringtoneModelClass.audioUrl);
                      },
                      child: Container(
                        width: 240,
                        height: 240,
                        child: Icon(
                          Icons.play_circle_fill_outlined,
                          color: Colors.white.withOpacity(0.7),
                          size: 84.0,
                        ),
                      ),
                    )

                  ],
                ),
                SizedBox(
                  height: tDefaultSize/4,
                ),
                Text("${ringtoneModelClass.duration} sec",
                  style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 12.0,
                      color: Colors.white
                  ),
                ),
                SizedBox(
                  height: tDefaultSize * 2 ,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        String linkToShare = ringtoneModelClass.audioUrl; // Replace with your link
                      //  print("data==");
                        shareLink(linkToShare);
                      },
                      icon: const Icon(Icons.share,
                          size: 25,
                          color: Colors.white),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return BottomPopUpContent();
                          },
                        );
                      },
                      icon: const Icon(Icons.arrow_downward,
                          size: 25,
                          color: Colors.white),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    IconButton(
                      onPressed: () {
                        checkAndRequestPermissions();
                        downloadMP3File(ringtoneModelClass.audioUrl);
                      },
                      icon: const Icon(Icons.favorite_border,
                          size: 25,
                          color: Colors.white),
                    ),

                  ],
                )
              ]
            ),
          )
        ],
      ),
    );
  }

void shareLink(String link)
{
  try {
    Share.share(link);
  } catch (e) {
    print('data===: $e');
  }
}

  Future<void>playMusic(String audioUrl) async {
   // print("data===1"+audioUrl.toString()+"  current playing "+currentPlayingUrl.value.toString()+"isplaying"+isPlaying.value.toString());
    try {
      if (audioUrl == currentPlayingUrl && isPlaying) {
        print("data===2");
        await audioPlayer.pause();
        isPlaying = false;
      }
      else
      {
        print("data===4");
        await audioPlayer.play(UrlSource(audioUrl));
        currentPlayingUrl= audioUrl;
        isPlaying  = true;
      }
    }
    catch (e) {
    }
  }

  Future<void> downloadMP3File(String url) async {
    print('File===: ${url}');
    showToast("called");
    Random random = Random();
    int number = random.nextInt(10);
    String fileName = "ringtone$number.mp3";
    final request = await http.get(Uri.parse(url));
    try {
      if (request.statusCode == 200)
      {
        var bytes = request.bodyBytes;
        var dir = await getApplicationSupportDirectory(); // Use getApplicationSupportDirectory() instead of getApplicationDocumentsDirectory()
        File file = File('${dir.path}/${fileName}');
         print("file download ${bytes.toString()}");
        await file.writeAsBytes(bytes);
        print('File===: ${file.path}');

        bool fileExists = await file.exists();
        print('File exists: $fileExists');

        showToast("Saved File");

        final result = await OpenFile.open(file.path);

        DefaultNotificationSoundPage().setDefaultNotificationSound(file.path);
        if (result.type == ResultType.done) {
           showToast("oened file");
        } else {
          showToast("failed opened");
        }
      }
      else {
        showToast("error");
      }
    }
    catch (e)
    {
      print('File downloading file: $e');
      showToast(e.toString());
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

  Future<void> checkAndRequestPermissions() async {
    PermissionStatus status = await Permission.storage.status;
    print("permisstion== called");
    if (status.isDenied) {
      print("permisstion== denied");
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (permissionStatus.isGranted) {
        // Permission granted. You can proceed with file operations.
        print("permisstion== granted");
      }
    } else if (status.isGranted) {
      // Permission already granted. You can proceed with file operations.
      print("permisstion== is Granted");
    } else if (status.isPermanentlyDenied) {
      print("permisstion== permanent denied");
      // Permission is permanently denied.
      // You can show a dialog to guide the user to the app settings.
    }
  }

}
class DefaultNotificationSoundPage{
  static const platform = MethodChannel('default_notification_sound');

  void setDefaultNotificationSound(String ringtoneUri) async {
    try {
      await platform.invokeMethod('setDefaultNotificationSound', {'ringtoneUri': ringtoneUri});
    } on PlatformException catch (e) {
      print('Failed to set default notification sound: ${e.message}');
    }
  }
}
class BottomPopUpContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
           GestureDetector(
             onTap: (){
               Navigator.pop(context);
             },
             child: Row(
               children: [
                 Icon(
                   Icons.notifications,
                   size: 22,
                   color: tWhiteColor,
                 ),

                 SizedBox(
                     width: 16.0
                 ),

                 Text('SET NOTIFICATION',
                 style: TextStyle(
                   color: tWhiteColor,
                   fontSize: 12.0
                 ),
                 ),
               ],
             ),
           ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.volume_up,
                  size: 22,
                  color: tWhiteColor,
                ),

                SizedBox(
                    width: 16.0
                ),

                Text('SET RINGTONE',
                  style: TextStyle(
                      color: tWhiteColor,
                      fontSize: 12.0
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.volume_up,
                  size: 22,
                  color: tWhiteColor,
                ),

                SizedBox(
                    width: 16.0
                ),

                Text('SET RINGTONE',
                  style: TextStyle(
                      color: tWhiteColor,
                      fontSize: 12.0
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.0),
          GestureDetector(
            onTap: (){
             // downloadMP3File(rin, "filename");
               Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.volume_up,
                  size: 22,
                  color: tWhiteColor,
                ),

                SizedBox(
                    width: 16.0
                ),

                Text('SAVE TO MEDIA FOLDER',
                  style: TextStyle(
                      color: tWhiteColor,
                      fontSize: 12.0
                  ),
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
}

