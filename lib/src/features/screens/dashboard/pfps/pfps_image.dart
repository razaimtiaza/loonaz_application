import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:loonaz_application/src/features/models/pfps_model/pfps_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class pfpsDetailScreen extends StatelessWidget {
  final List<Data> imageDataList; // List of images
  final int initialIndex; // Index of the selected image
// The URL of the selected image

  pfpsDetailScreen({
    super.key,
    required this.imageDataList,
    required this.initialIndex,
  });

  Data _selectedItem = Data();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
          itemCount: imageDataList.length,
          controller: PageController(initialPage: initialIndex),
          itemBuilder: (BuildContext context, int index) {
            var item = imageDataList[index];
            return Center(
              child: Container(
                height: height * 0.8,
                width: wid * 0.9,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color:
                      const Color.fromARGB(255, 47, 41, 41), // Background color
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20.0),
                    top: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 204, 193, 193)
                          .withOpacity(0.4),
                      blurRadius: 6.0,
                      spreadRadius: 4.0,
                    ),
                  ],
                ),
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
                      child: Image.network(
                        item.file_high ?? "",
                        fit: BoxFit.cover,
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
          ],
        );
      },
    );
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper set successfully!'),
            duration: Duration(seconds: 1), // Adjust the duration as needed
          ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper set successfully!'),
            duration: Duration(seconds: 1), // Adjust the duration as needed
          ),
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Wallpaper set successfully!'),
            duration: Duration(seconds: 1), // Adjust the duration as needed
          ),
        );
      }
      print(result);
    } on PlatformException {}
  }
}
