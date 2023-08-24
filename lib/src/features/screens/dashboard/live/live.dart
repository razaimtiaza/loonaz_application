import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:loonaz_application/src/features/apis/live_api/Live_view_model.dart';
import 'package:loonaz_application/src/features/models/live_wallaper/live_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/live/live_vide.dart';

class Live extends StatefulWidget {
  const Live({super.key});

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  Livemodel livemodel = Livemodel();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: FutureBuilder<Livewallpaper>(
          future: livemodel.fetchData(),
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
                          builder: (context) => VideoScreen(
                              videoUrl: item.file_video ?? '',
                              image: item.file_thumb ?? ""),
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
                              item.file_thumb ?? '',
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
