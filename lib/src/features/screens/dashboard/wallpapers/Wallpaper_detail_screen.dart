// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_gallery_saver/image_gallery_saver.dart';
// import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:share/share.dart';
// import 'package:http/http.dart' as http;
// import '../../../../constants/colors.dart';
// import '../../../../constants/sizes.dart';

// class WallpaperDetailScreen extends StatelessWidget{

//   WallpaperDetailScreen({Key? key,
//     required this.wallpaperModelClass}) : super(key: key);

//   final WallpaperModelClass wallpaperModelClass;

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         elevation: 0,
//         title: Row(
//           children: [
//             Icon(
//               Icons.person_2_rounded,
//               color: Colors.white.withOpacity(0.7),
//               size: 30.0,
//             ),
//             SizedBox(
//               width: 5.0,
//             ),
//             Text("byt119718")
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Colors.black, Colors.black], // Replace with your desired colors
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//               borderRadius: BorderRadius.all(Radius.circular(defaultPadding/2)),
//             ),
//             child: Column(
//                 children :
//                 [
//                   SizedBox(
//                     height: tDefaultSize,
//                   ),
//                   SizedBox(
//                     height: tDefaultSize/4,
//                   ),
//                   Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(5.0), // Change the radius as needed
//                         child: Image(// Replace with your image URL
//                           width: 300,
//                           height: 480,
//                           fit: BoxFit.cover,
//                           image: NetworkImage(wallpaperModelClass.imageUrl),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: tDefaultSize/4,
//                   ),
//                   SizedBox(
//                     height: tDefaultSize * 2 ,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         onPressed: () {
//                           String linkToShare = wallpaperModelClass.imageUrl; // Replace with your link
//                           //  print("data==");
//                           shareLink(linkToShare);
//                         },
//                         icon: const Icon(Icons.share,
//                             size: 25,
//                             color: Colors.white),
//                       ),
//                       const SizedBox(
//                         width: 20.0,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           showModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return BottomPopUpContent(ob : wallpaperModelClass);
//                             },
//                           );
//                         },
//                         icon: const Icon(Icons.arrow_downward,
//                             size: 25,
//                             color: Colors.white),
//                       ),
//                       SizedBox(
//                         width: 20.0,
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           //downloadMP3File(ringtoneModelClass.audioUrl);
//                         },
//                         icon: const Icon(Icons.favorite_border,
//                             size: 25,
//                             color: Colors.white),
//                       ),

//                     ],
//                   )
//                 ]
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void shareLink(String link)
//   {
//     try {
//       Share.share(link);
//     } catch (e) {
//       print('data===: $e');
//     }
//   }
// }

// class BottomPopUpContent extends StatelessWidget {
//   BottomPopUpContent({Key? key,
//     required this.ob}) : super(key: key);

//   final WallpaperModelClass ob;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.grey,
//       padding: EdgeInsets.all(16.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           GestureDetector(
//             onTap: (){
//               WallpaperSetter();
//               Navigator.pop(context);

//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.wallpaper,
//                   size: 22,
//                   color: tWhiteColor,
//                 ),

//                 SizedBox(
//                     width: 16.0
//                 ),

//                 Text('SET WALLPAPER',
//                   style: TextStyle(
//                       color: tWhiteColor,
//                       fontSize: 12.0
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16.0),
//           GestureDetector(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.lock,
//                   size: 22,
//                   color: tWhiteColor,
//                 ),

//                 SizedBox(
//                     width: 16.0
//                 ),

//                 Text('SET SET LOCK SCREEN',
//                   style: TextStyle(
//                       color: tWhiteColor,
//                       fontSize: 12.0
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16.0),
//           GestureDetector(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.image,
//                   size: 22,
//                   color: tWhiteColor,
//                 ),

//                 SizedBox(
//                     width: 16.0
//                 ),

//                 Text('SET BOTH',
//                   style: TextStyle(
//                       color: tWhiteColor,
//                       fontSize: 12.0
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 16.0),
//           GestureDetector(
//             onTap: (){
//               downloadSaveAndShowImage(ob.imageUrl);
//               Navigator.pop(context);
//             },
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.save_alt_outlined,
//                   size: 22,
//                   color: tWhiteColor,
//                 ),

//                 SizedBox(
//                     width: 16.0
//                 ),

//                 Text('SAVE TO MEDIA FOLDER',
//                   style: TextStyle(
//                       color: tWhiteColor,
//                       fontSize: 12.0
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   void showToast(String message) {
//     Fluttertoast.showToast(
//       msg: message,
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1,
//       backgroundColor: Colors.black45,
//       textColor: Colors.white,
//       fontSize: 16.0,
//     );
//   }

//   Future<void> downloadSaveAndShowImage(String imageUrl) async {
//     final response = await http.get(Uri.parse(imageUrl));

//     if (response.statusCode == 200) {
//       // Get the app's document directory for saving the image
//       final appDocDir = await getApplicationDocumentsDirectory();
//       final imagePath = appDocDir.path + '/downloaded_image.jpg';

//       // Write the image to the file
//       final File imageFile = File(imagePath);
//       await imageFile.writeAsBytes(response.bodyBytes);

//       // Save the image to the gallery
//       final result = await ImageGallerySaver.saveFile(imagePath);
//       if (result['isSuccess']) {
//         print('Image downloaded, saved, and shown in gallery');
//         showToast("Downloaded");
//       } else {
//         print('Failed to save image to gallery');
//         showToast("Error");
//       }
//     } else {
//       print('Failed to download image. Status code: ${response.statusCode}');
//     }
//   }
// }
// class WallpaperSetter extends StatelessWidget {
//   static const platform = MethodChannel('com.example/wallpaper');

//   Future<void> setWallpaper(String wallpaperPath) async {
//     try {
//       await platform.invokeMethod('setWallpaper', {'wallpaperPath': wallpaperPath});
//       print('Wallpaper set successfully');
//     } catch (e) {
//       print('Failed to set wallpaper: $e');
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: ElevatedButton(
//         onPressed: () {
//           // Replace this with your logic to select an image from device storage
//           String wallpaperImagePath = 'assets/images/img1.jpg';
//           setWallpaper(wallpaperImagePath);
//         },
//         child: Text('Set Wallpaper'),
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:palette_generator/palette_generator.dart';

// ignore: must_be_immutable

class WallDetailScreen extends StatefulWidget {
  final List<Data> imageDataList; // List of images
  final int initialIndex;
  final String heroTag; // Index of the selected image

  const WallDetailScreen({
    super.key,
    required this.imageDataList,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  _WallDetailScreenState createState() => _WallDetailScreenState();
}

class _WallDetailScreenState extends State<WallDetailScreen> {
  List<PaletteGenerator?> _paletteGenerators = [];
  int _currentIndex = 0;
  Color _backgroundColor = Colors.black;
  Data _selectedItem = Data();
  @override
  void initState() {
    super.initState();
    // Initialize _paletteGenerators with null values for each image.
    _paletteGenerators = List.generate(
      widget.imageDataList.length,
      (_) => null,
    );
    _currentIndex = widget.initialIndex;
    _loadImageAndGeneratePalette(
        widget.imageDataList[widget.initialIndex].file_high ?? "",
        widget.initialIndex);
  }

  void _loadImageAndGeneratePalette(String imageUrl, int index) async {
    final paletteGenerator = await PaletteGenerator.fromImageProvider(
      NetworkImage(imageUrl),
      size: const Size(300, 480),
    );

    setState(() {
      _paletteGenerators[index] = paletteGenerator;
      _backgroundColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: PageView.builder(
          itemCount: widget.imageDataList.length,
          controller: PageController(initialPage: widget.initialIndex),
          onPageChanged: (index) {
            // Update the current index and load the palette for the new image.
            setState(() {
              _currentIndex = index;
            });
            if (_paletteGenerators[index] == null) {
              _loadImageAndGeneratePalette(
                  widget.imageDataList[index].file_high ?? "", index);
            } else {
              _backgroundColor =
                  _paletteGenerators[index]!.dominantColor?.color ??
                      Colors.black;
            }
          },
          itemBuilder: (BuildContext context, int index) {
            var item = widget.imageDataList[index];
            return Center(
              child: SizedBox(
                height: height * 0.8,
                width: wid * 0.9,
                // padding: const EdgeInsets.all(16.0),
                // decoration: BoxDecoration(
                //   color: Colors.black,
                //   // _paletteGenerator?.dominantColor?.color ?? Colors.black,
                //   borderRadius: const BorderRadius.vertical(
                //     bottom: Radius.circular(20.0),
                //     top: Radius.circular(20.0),
                //   ),
                //   boxShadow: [
                //     BoxShadow(
                //       color: const Color.fromARGB(255, 204, 193, 193)
                //           .withOpacity(0.4),
                //       blurRadius: 6.0,
                //       spreadRadius: 4.0,
                //     ),
                //   ],
                // ),
                child: Column(
                  children: [
                    Text(
                      item.title ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Expanded(
                      child: Hero(
                        tag: widget.heroTag,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              20.0), // Rounded corners for the image
                          child: Image.network(
                            item.file_high ?? "",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.size ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          item.views ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Implement the share functionality here
                            _shareImage(context, item.file_high ?? "");
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.download,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            _selectedItem = item;
                            _showDownloadOptions(context);
                            // Implement the download functionality here
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.favorite,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            // Implement the favorite functionality here
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> _shareImage(BuildContext context, String imageUrl) async {
    // Download the image
    final response = await http.get(Uri.parse(imageUrl));
    final Uint8List bytes = response.bodyBytes;

    // Save the image to a temporary directory
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/shared_image.png');
    await tempFile.writeAsBytes(bytes);

    // Share the image using the share package
    Share.shareFiles(
      [tempFile.path],
      subject:
          'Check out this image!', // Optional subject for the shared content
    );
  }

  void _showDownloadOptions(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: const Color.fromARGB(255, 189, 179, 179),
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.wallpaper),
              title: const Text('Set as Wallpaper'),
              onTap: () {
                setWallpaperhome(context, _selectedItem.file_high ?? "");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Set as Lock Screen'),
              onTap: () {
                // Implement setting the image as lock screen
                setWallpaperlock(context, _selectedItem.file_high ?? "");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mobile_screen_share),
              title: const Text('Set as Both'),
              onTap: () {
                // Implement setting the image as both wallpaper and lock screen
                setWallpaper(context, _selectedItem.file_high ?? "");

                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.save_alt_outlined,
              ),
              title: const Text('Set to Media Folder'),
              onTap: () async {
                // Implement setting the image as both wallpaper and lock screen
                await _saveToMediaFolder(_selectedItem.file_high ?? '');
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveToMediaFolder(String imageUrl) async {
    // Request storage permission
    final PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final imagePath = '${appDocDir.path}/downloaded_image.jpg';
        final File imageFile = File(imagePath);
        await imageFile.writeAsBytes(response.bodyBytes);

        final result = await ImageGallerySaver.saveFile(imagePath);
        if (result['isSuccess']) {
          Get.snackbar(
            'Image Saved',
            'Image saved to Media Folder',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save image',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to download image. Status code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to save the image.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> setWallpaper(BuildContext context, String image) async {
    try {
      String url = image;
      int location = WallpaperManager
          .BOTH_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        // Display a Snackbar
        Get.snackbar(
          'Successfull',
          'Set Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 7, 231, 86),
          colorText: Colors.white,
        );
      }
      print(result);
    } on PlatformException {}
  }

  Future<void> setWallpaperhome(BuildContext context, String image) async {
    try {
      String url = image;
      int location = WallpaperManager
          .HOME_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        // Display a Snackbar
        Get.snackbar(
          'Successfull',
          'Set Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 7, 231, 86),
          colorText: Colors.white,
        );
      }

      print(result);
    } on PlatformException {}
  }

  Future<void> setWallpaperlock(BuildContext context, String image) async {
    try {
      String url = image;
      int location = WallpaperManager
          .LOCK_SCREEN; // or location = WallpaperManager.LOCK_SCREEN;
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result =
          await WallpaperManager.setWallpaperFromFile(file.path, location);
      if (result) {
        // Display a Snackbar
        Get.snackbar(
          'Successfull',
          'Set Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 7, 231, 86),
          colorText: Colors.white,
        );
      }
      print(result);
    } on PlatformException {}
  }
}
