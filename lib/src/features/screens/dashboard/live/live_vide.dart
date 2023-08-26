// ignore_for_file: unused_field

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share/share.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

import '../../../models/live_wallaper/live_model.dart';

class VideoScreen extends StatefulWidget {
  final List<Data>? videos; // Change the type to List<Data>?
  final int initialIndex; // Index of the selected image

  const VideoScreen({
    super.key,
    this.videos,
    required this.initialIndex,
  });

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _videoController;
  late bool _isPlaying = false;
  final int _currentPageIndex = 0;
  late PageController _pageController;
  List<PaletteGenerator?> _paletteGenerators = [];
  int _currentIndex = 0;
  Color _backgroundColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
    _initializeVideoController(widget.initialIndex);
    // Initialize _paletteGenerators with null values for each image.
    _paletteGenerators = List.generate(
      widget.videos!.length,
      (_) => null,
    );
    _currentIndex = widget.initialIndex;
    _loadImageAndGeneratePalette(
        widget.videos![widget.initialIndex].file_thumb ?? "",
        widget.initialIndex);
  }

  void _videoListener() {
    if (!_videoController.value.isPlaying &&
        _videoController.value.position == _videoController.value.duration) {
      setState(() {
        _isPlaying = false;
      });
    }
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

  void _initializeVideoController(int index) {
    _videoController =
        VideoPlayerController.network(widget.videos![index].file_video ?? "")
          ..initialize().then((_) {
            setState(() {});
            _videoController.addListener(_videoListener);
          });
  }

  Data _selectedItem = Data();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: _backgroundColor,
      body: Center(
        child: Container(
          height: height * 0.8,
          width: wid * 0.8,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 47, 41, 41), // Background color
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(20.0),
              top: Radius.circular(20.0),
            ),
            boxShadow: [
              BoxShadow(
                color:
                    const Color.fromARGB(255, 204, 193, 193).withOpacity(0.4),
                blurRadius: 6.0,
                spreadRadius: 4.0,
              ),
            ],
          ),
          child: PageView.builder(
              itemCount: widget.videos!.length,
              controller: PageController(initialPage: widget.initialIndex),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _loadImageAndGeneratePalette(
                    widget.videos![index].file_thumb ?? "", index);
                setState(() {
                  _videoController.dispose();
                  _initializeVideoController(
                      index); // Update the video controller with the correct index
                  _isPlaying = false;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                var item = widget.videos?[index];
                if (!_videoController.value.isInitialized) {
                  return const Center(
                      child: CircularProgressIndicator()); // Loading indicator
                }
                return Center(
                  child: Container(
                    height: height * 0.8,
                    width: wid * 0.8,
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(
                          255, 47, 41, 41), // Background color
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          item!.title ?? "",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Expanded(
                          child: AspectRatio(
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
                                      _isPlaying =
                                          _videoController.value.isPlaying;
                                    });
                                  },
                                  icon: Icon(
                                    _isPlaying ||
                                            _videoController.value.position !=
                                                Duration.zero
                                        ? (_isPlaying
                                            ? Icons.pause
                                            : Icons.play_arrow)
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
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
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                _shareImage(context, item.file_thumb ?? "");
                              },
                              icon: const Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectedItem = item;
                                _showDownloadOptions(context);
                              },
                              icon: const Icon(Icons.file_download,
                                  color: Colors.white),
                            ),
                            IconButton(
                              onPressed: () {
                                // Implement favoriting functionality here
                              },
                              icon: const Icon(Icons.favorite,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),
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
                setWallpaperhome(context, _selectedItem.file_thumb ?? "");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Set as Lock Screen'),
              onTap: () {
                // Implement setting the image as lock screen
                setWallpaperlock(context, _selectedItem.file_thumb ?? "");
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.mobile_screen_share),
              title: const Text('Set as Both'),
              onTap: () {
                // Implement setting the image as both wallpaper and lock screen
                setWallpaper(context, _selectedItem.file_thumb ?? "");

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
                await _saveVideoToMediaFolder(_selectedItem.file_video ?? '');
                // ignore: use_build_context_synchronously
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _saveVideoToMediaFolder(String videoUrl) async {
    final PermissionStatus status = await Permission.storage.request();

    if (status.isGranted) {
      final response = await http.get(Uri.parse(videoUrl));

      if (response.statusCode == 200) {
        final appDocDir = await getApplicationDocumentsDirectory();
        final videoPath = '${appDocDir.path}/downloaded_video.mp4';
        final File videoFile = File(videoPath);
        await videoFile.writeAsBytes(response.bodyBytes);

        final result = await ImageGallerySaver.saveFile(videoPath);
        if (result['isSuccess']) {
          Get.snackbar(
            'Video Saved',
            'Video saved to Media Folder',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          Get.snackbar(
            'Error',
            'Failed to save video',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to download video. Status code: ${response.statusCode}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Permission Denied',
        'Storage permission is required to save the video.',
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
