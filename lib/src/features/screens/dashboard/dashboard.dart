import 'package:flutter/material.dart';
import 'package:loonaz_application/src/constants/text_strings.dart';
import 'pfps/pfps.dart';
import 'ringtones/ringtones.dart';
import 'wallpapers/wallpapers.dart';
import 'dps/dps.dart';
import 'live/live.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int currentIndex = 0;
  final screensList = [const Wallpapers(), Ringtones(), Live(), Dps(), Pfps()];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return WillPopScope(
      onWillPop: () async {
        if (currentIndex != 0) {
          // If the current tab is not the HomeScreen, select the HomeScreen
          setState(() {
            currentIndex = 0;
          });
          return false;
        } else {
          // If the current tab is the HomeScreen, exit the application
          return true;
        }
      },
      child: Scaffold(
        //  note : agr hr cheez by default use kro gey to look achi ay gi
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor:
              Colors.white, // jo click nai ha on ka color orange ho ga
          selectedItemColor:
              Colors.lightBlue, // jo select ha on ka color blue ho ga
          backgroundColor: Colors.blueGrey,
          //  iconSize: 40,
          //   selectedFontSize: 20,
          //   unselectedFontSize: 10,
          //  showSelectedLabels: false,  //  not show lable select
          //  showUnselectedLabels: false,  //no show lable unslected
          currentIndex: currentIndex,
          onTap: (index) => setState(() {
            currentIndex = index;
          }),
          items: const [
            BottomNavigationBarItem(
              // icon: _buildNavIcon(Icons.wallpaper, 1, badge: 3),
              icon: Icon(Icons.wallpaper),
              label: wallpaper,
              //backgroundColor: Colors.white  // is k bacground color blue ho ga jb click krey gey
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.music_video),
                label: ringtones,
                backgroundColor: Colors
                    .red // is k bacground color red ho ga jb click krey gey
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_arrow),
                label: live,
                backgroundColor: Colors
                    .blue // is k bacground color blue ho ga jb click krey gey
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.perm_identity_sharp),
                label: dps,
                backgroundColor: Colors
                    .blue // is k bacground color blue ho ga jb click krey gey
                ),
            BottomNavigationBarItem(
                icon: Icon(Icons.image),
                label: pfps,
                backgroundColor: Colors
                    .blue // is k bacground color blue ho ga jb click krey gey
                ),
          ],
        ),
        body: screensList[
            currentIndex], // is trha jb kisi or activity se wapis ay gey to acitvity again refresh ho gi
        // body: IndexedStack(   // is trha nai ho gi
        //   children: screens,
        // )
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, {int badge = 0}) {
    return Container(
      // width: MediaQuery.of(context).size.width,
      // height: kBottomNavigationBarHeight,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                  child: Container(
                child: Stack(
                  // ignore: deprecated_member_use
                  //overflow: Overflow.visible,
                  children: [
                    Icon(
                      icon,
                      // color: Colors.red,
                      // size: 40,
                    ),
                    index != 0
                        ? Positioned(
                            right: -5.0,
                            top: -5.0,
                            child: Container(
                              height: 20,
                              width: 20,
                              constraints: const BoxConstraints(
                                  maxHeight: 45, maxWidth: 45),
                              decoration: const BoxDecoration(
                                color: Colors.lightGreen,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text("$badge"),
                              ),
                            ),
                          )
                        : Container(
                            child: const SizedBox.shrink(),
                          ),
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
