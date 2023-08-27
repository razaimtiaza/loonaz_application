import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:loonaz_application/src/features/models/dps_model/dps_model.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

// ignore: must_be_immutable

class ImageDetailScreen extends StatefulWidget {
  final List<Data> imageDataList; // List of images
  final int initialIndex; // Index of the selected image
  final String heroTag;

  const ImageDetailScreen({
    super.key,
    required this.imageDataList,
    required this.initialIndex,
    required this.heroTag,
  });

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
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
                //   color:
                //       const Color.fromARGB(255, 47, 41, 41), // Background color
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
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.wallpaper),
              title: const Text('Set as Wallpaper'),
              onTap: () {
                setWallpaperhome(context, _selectedItem.file_low ?? "");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Set as Lock Screen'),
              onTap: () {
                // Implement setting the image as lock screen
                setWallpaperlock(context, _selectedItem.file_low ?? "");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mobile_screen_share),
              title: const Text('Set as Both'),
              onTap: () {
                // Implement setting the image as both wallpaper and lock screen
                setWallpaper(context, _selectedItem.file_low ?? "");

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
