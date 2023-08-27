import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:loonaz_application/src/features/controllers/ringtone_controller.dart';
import 'package:loonaz_application/src/features/models/ringtones/ringone_model.dart';
import 'package:loonaz_application/src/features/screens/dashboard/ringtones/ringtone_detail_screen.dart';

import '../../../../constants/sizes.dart';

class Ringtones extends StatefulWidget {
  const Ringtones({super.key});

  @override
  State<Ringtones> createState() => _RingtonesState();
}

class _RingtonesState extends State<Ringtones> {
  final ringtoneController = Get.put(RingtoneScreenController());
  final AudioPlayer audioPlayer = AudioPlayer();
  String? currentPlayingUrl;
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    // final list = RingtoneModelClass.list;
    // TODO: implement build
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
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Latest",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16)),
                Obx(
                  () => ringtoneController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : _buildListView(ringtoneController.itemList),
                )
              ],
            ),
          )),
    );
  }

  Future<void> _playMusic1(String audioUrl) async {
    print("data===1$audioUrl");
    try {
      if (audioUrl == currentPlayingUrl && isPlaying) {
        print("data===2");
        await audioPlayer.pause();
        setState(() {
          print("data===3");
          isPlaying = false;
        });
      } else {
        print("data===4");
        await audioPlayer.play(UrlSource(audioUrl));
        setState(() {
          print("data===5");
          currentPlayingUrl = audioUrl;
          isPlaying = true;
        });
      }
    } catch (e) {}
  }

  Widget _buildListView(List<RingtoneModelClass> itemList) {
    final List<RingtoneModelClass> list = itemList;
//  // print("data == itemlist");
//   return ListView.builder(
//     itemCount: itemList.length,
//     itemBuilder: (context, index) {
//       return ListTile(
//         title: Text(itemList[index].audioUrl,
//         style: TextStyle( color: Colors.black),),
//         subtitle: Text(itemList[index].audioUrl),
//       );
//     },
//   );
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: List.generate(
              list.length,
              (index) => GestureDetector(
                  onTap: () {
                    // Navigate to the detail screen when an item is tapped
                    ringtoneController.pauseSong();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RingtoneDetailScreen(
                          itemList: list,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(defaultPadding / 2 - 4),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // _playMusic(list[index].audioUrl);
                              ringtoneController
                                  .playMusic(list[index].audioUrl);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.lightGreen,
                                        Colors.blueGrey
                                      ], // Replace with your desired colors
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(defaultPadding / 2)),
                                  ),
                                ),
                                SizedBox(
                                  width: 90,
                                  height: 90,
                                  child: Icon(
                                    Icons.play_circle_fill_outlined,
                                    color: Colors.white.withOpacity(0.7),
                                    size: 42.0,
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            width: tDefaultSize / 2,
                          ),
                          GestureDetector(
                            onTap: () {
                              ringtoneController.pauseSong();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RingtoneDetailScreen(
                                    itemList: list,
                                    initialIndex: index,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  list[index].title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12.0,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: tDefaultSize / 4,
                                ),
                                Text(
                                  list[index].catname,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0,
                                      color: Colors.white),
                                ),
                                const SizedBox(
                                  height: tDefaultSize / 4,
                                ),
                                Text(
                                  list[index].duration.toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10.0,
                                      color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ))),
        ));
  }
}


/*class GradientContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueGrey, Colors.purple], // Replace with your desired colors
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0.0, 2.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Gradient Container',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
*/

// class RadialGradientContainer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 200,
//       height: 200,
//       decoration: BoxDecoration(
//         gradient: RadialGradient(
//           colors: [Colors.orange, Colors.yellow], // Replace with your desired colors
//           center: Alignment.center,
//           radius: 0.7,
//         ),
//         borderRadius: BorderRadius.circular(16.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             offset: Offset(0.0, 2.0),
//             blurRadius: 6.0,
//           ),
//         ],
//       ),
//       child: Center(
//         child: Text(
//           'Radial Gradient',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 20.0,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }