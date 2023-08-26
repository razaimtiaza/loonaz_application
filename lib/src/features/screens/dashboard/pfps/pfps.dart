import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loonaz_application/src/features/apis/pfps/pfps_model.dart';
import 'package:loonaz_application/src/features/models/pfps_model/pfps_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/pfps/pfps_image.dart';

class Pfps extends StatefulWidget {
  const Pfps({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Pfps> {
  pfpsmodel pfps = pfpsmodel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: FutureBuilder<pfpsWallpaper>(
          future: pfps.fetchpfpsData(),
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
                          builder: (context) => pfpsDetailScreen(
                              imageDataList: snapshot.data?.data?[0] ??
                                  [], // Pass the list of images
                              initialIndex: index),
                        ),
                      );
                    },
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
