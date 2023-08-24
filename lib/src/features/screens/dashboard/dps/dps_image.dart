import 'dart:io';

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class ImageDetailScreen extends StatelessWidget {
  final String imageUrl; // The URL of the selected image

  const ImageDetailScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Expanded(
              child: Image.network(
                imageUrl,
                // fit: BoxFit.cover,
              ),
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
                    _shareImage(context, imageUrl);
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.download,
                    color: Colors.white,
                  ),
                  onPressed: () {
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
                setWallpaperhome(context, imageUrl);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Set as Lock Screen'),
              onTap: () {
                // Implement setting the image as lock screen
                setWallpaperlock(context, imageUrl);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mobile_screen_share),
              title: const Text('Set as Both'),
              onTap: () {
                // Implement setting the image as both wallpaper and lock screen
                setWallpaper(context, imageUrl);

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
