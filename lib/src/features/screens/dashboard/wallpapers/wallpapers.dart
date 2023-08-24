// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:loonaz_application/src/features/controllers/wallpaper_controller.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/popular_model.dart';
import 'package:loonaz_application/src/features/models/dashboard/wallpaper/wallpaper_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/wallpapers/Wallpaper_detail_screen.dart';

import '../../../../constants/sizes.dart';

class Wallpapers extends StatefulWidget {
  const Wallpapers({super.key});

  @override
  State<Wallpapers> createState() => _WallpapersState();
}

class _WallpapersState extends State<Wallpapers> {
  final wallpaperController = Get.put(WallpaperController());
  @override
  Widget build(BuildContext context) {
    final list = PopularModelClass.list;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                height: 40.0,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0), // Adjust vertical alignment
                    alignLabelWithHint: true,
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    filled: true,
                    fillColor: Colors.blueGrey,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
          color: Colors.black,
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Obx(
                () => wallpaperController.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : _buildListView(wallpaperController.itemList),
              ),
            ],
          )),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({Key? key, required this.title, required this.pressSeeAll})
      : super(key: key);
  final String title;
  final VoidCallback pressSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              // ignore: deprecated_member_use
              .subtitle1!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        TextButton(
          onPressed: pressSeeAll,
          child: const Text(
            "See All",
            style: TextStyle(color: Colors.black54),
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({Key? key, required this.id, required this.imageUrl})
      : super(key: key);

  final int id;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(defaultBorderRadius),
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: defaultPadding / 4, vertical: defaultPadding / 2),
        child: Column(
          children: [
            Image(width: 50, height: 50, image: AssetImage(imageUrl)),
            const SizedBox(height: defaultPadding / 2),
          ],
        ),
      ),
    );
  }
}

Widget _buildListView(List<WallpaperModelClass> itemList) {
  final List<WallpaperModelClass> list = itemList;
  return GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // Number of columns
        mainAxisSpacing: 5.0, // Vertical spacing between grid items
        crossAxisSpacing: 3.0, // Horizontal spacing between grid items
        childAspectRatio: 0.45),
    itemCount: list.length, // Total number of items in the grid
    itemBuilder: (BuildContext context, int index) {
      return Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: GestureDetector(
          onTap: () {
            Get.to(WallpaperDetailScreen(wallpaperModelClass: list[index]));
          },
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(5.0), // Change the radius as needed
            child: Image(
              // Replace with your image URL
              width: 100,
              height: 280,
              fit: BoxFit.cover,
              image: NetworkImage(list[index].imageUrl),
            ),
          ),
        ),
      );
    },
  );
}
