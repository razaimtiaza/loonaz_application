import 'dart:io';

import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

class VideoScreen extends StatefulWidget {
  final String videoUrl;
  final String image;

  const VideoScreen({super.key, required this.videoUrl, required this.image});

  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoController;
  late bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _videoController.addListener(_videoListener);
      });
  }

  void _videoListener() {
    if (!_videoController.value.isPlaying &&
        _videoController.value.position == _videoController.value.duration) {
      setState(() {
        _isPlaying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _videoController.value.aspectRatio,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  VideoPlayer(_videoController),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_videoController.value.isPlaying) {
                          _videoController.pause();
                        } else {
                          _videoController.play();
                        }
                        _isPlaying = _videoController.value.isPlaying;
                      });
                    },
                    icon: Icon(
                      _isPlaying ||
                              _videoController.value.position != Duration.zero
                          ? (_isPlaying ? Icons.pause : Icons.play_arrow)
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    _shareImage(context, widget.image);
                  },
                  icon: const Icon(
                    Icons.share,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showDownloadOptions(context);
                  },
                  icon: const Icon(Icons.file_download, color: Colors.white),
                ),
                IconButton(
                  onPressed: () {
                    // Implement favoriting functionality here
                  },
                  icon: const Icon(Icons.favorite, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.removeListener(_videoListener);
    _videoController.dispose();
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
                setWallpaperhome(context, widget.image);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Set as Lock Screen'),
              onTap: () {
                // Implement setting the image as lock screen
                setWallpaperlock(context, widget.image);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mobile_screen_share),
              title: const Text('Set as Both'),
              onTap: () {
                // Implement setting the image as both wallpaper and lock screen
                setWallpaper(context, widget.image);

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
