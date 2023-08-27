import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:loonaz_application/src/features/apis/dps_api/dps_model.dart';
import 'package:loonaz_application/src/features/models/dps_model/dps_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/dps/dps_image.dart';

class Dps extends StatefulWidget {
  const Dps({Key? key}) : super(key: key);

  @override
  State<Dps> createState() => _DpsState();
}

class _DpsState extends State<Dps> {
  Dpsmodel dpsmodel = Dpsmodel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
                    // Adjust vertical alignment
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
                    fillColor: const Color.fromARGB(255, 6, 33, 47),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder<GpsWallpaper>(
          future: dpsmodel.fetchdpsData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: SpinKitChasingDots(
                  color: Colors.blue,
                  size: 40,
                ),
              );
            } else {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 3.0,
                ),
                itemCount: snapshot.data?.data?[0].length ?? 0,
                itemBuilder: (context, index) {
                  var item = snapshot.data?.data?[0][index];
                  if (item == null) {
                    return Container(); // Handle if item is null
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageDetailScreen(
                              imageDataList: snapshot.data?.data?[0] ??
                                  [], // Pass the list of images
                              initialIndex: index,
                              heroTag: 'image_$index'),
                        ),
                      );
                    },
                    child: Hero(
                      tag: 'image_$index',
                      child: Container(
                        child: Stack(
                          children: [
                            SizedBox(
                              height: height,
                              width: width,
                              child: Image.network(
                                item.file_high ?? '',
                                fit: BoxFit.cover,
                              ),
                            ),
                            // You can add more widgets here like text, buttons, etc.
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
