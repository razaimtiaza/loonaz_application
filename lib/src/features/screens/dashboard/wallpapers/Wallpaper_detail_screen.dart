import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';


class WallpaperDetailScreen extends StatelessWidget{

  WallpaperDetailScreen({Key? key,
    required this.wallpaperModelClass}) : super(key: key);

  final WallpaperModelClass wallpaperModelClass;


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
                colors: [Colors.black, Colors.black], // Replace with your desired colors
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.all(Radius.circular(defaultPadding/2)),
            ),
            child: Column(
                children :
                [
                  SizedBox(
                    height: tDefaultSize,
                  ),
                  SizedBox(
                    height: tDefaultSize/4,
                  ),
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5.0), // Change the radius as needed
                        child: Image(// Replace with your image URL
                          width: 300,
                          height: 480,
                          fit: BoxFit.cover,
                          image: NetworkImage(wallpaperModelClass.imageUrl),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: tDefaultSize/4,
                  ),
                  SizedBox(
                    height: tDefaultSize * 2 ,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          String linkToShare = wallpaperModelClass.imageUrl; // Replace with your link
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
                              return BottomPopUpContent(ob : wallpaperModelClass);
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
                          //downloadMP3File(ringtoneModelClass.audioUrl);
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
}

class BottomPopUpContent extends StatelessWidget {
  BottomPopUpContent({Key? key,
    required this.ob}) : super(key: key);

  final WallpaperModelClass ob;

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
              WallpaperSetter();
              Navigator.pop(context);

            },
            child: Row(
              children: [
                Icon(
                  Icons.wallpaper,
                  size: 22,
                  color: tWhiteColor,
                ),

                SizedBox(
                    width: 16.0
                ),

                Text('SET WALLPAPER',
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
                  Icons.lock,
                  size: 22,
                  color: tWhiteColor,
                ),

                SizedBox(
                    width: 16.0
                ),

                Text('SET SET LOCK SCREEN',
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
                  Icons.image,
                  size: 22,
                  color: tWhiteColor,
                ),

                SizedBox(
                    width: 16.0
                ),

                Text('SET BOTH',
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
              downloadSaveAndShowImage(ob.imageUrl);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                Icon(
                  Icons.save_alt_outlined,
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


  Future<void> downloadSaveAndShowImage(String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));

    if (response.statusCode == 200) {
      // Get the app's document directory for saving the image
      final appDocDir = await getApplicationDocumentsDirectory();
      final imagePath = appDocDir.path + '/downloaded_image.jpg';

      // Write the image to the file
      final File imageFile = File(imagePath);
      await imageFile.writeAsBytes(response.bodyBytes);

      // Save the image to the gallery
      final result = await ImageGallerySaver.saveFile(imagePath);
      if (result['isSuccess']) {
        print('Image downloaded, saved, and shown in gallery');
        showToast("Downloaded");
      } else {
        print('Failed to save image to gallery');
        showToast("Error");
      }
    } else {
      print('Failed to download image. Status code: ${response.statusCode}');
    }
  }
}
class WallpaperSetter extends StatelessWidget {
  static const platform = MethodChannel('com.example/wallpaper');

  Future<void> setWallpaper(String wallpaperPath) async {
    try {
      await platform.invokeMethod('setWallpaper', {'wallpaperPath': wallpaperPath});
      print('Wallpaper set successfully');
    } catch (e) {
      print('Failed to set wallpaper: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Replace this with your logic to select an image from device storage
          String wallpaperImagePath = 'assets/images/img1.jpg';
          setWallpaper(wallpaperImagePath);
        },
        child: Text('Set Wallpaper'),
      ),
    );
  }
}