import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loonaz_application/src/constants/text_strings.dart';

import '../../../constants/sizes.dart';
import '../../controllers/splash_screen_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    // TODO: implement build
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          // alignment: Alignment.center,
          children: <Widget>[
            Obx(() => AnimatedOpacity(
                  duration: const Duration(milliseconds: 2000),
                  opacity: splashController.animate.value ? 1 : 0,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // const Image(
                        //   width: 100,
                        //   height: 100,
                        //   image: AssetImage(tSplashLogo),
                        // ),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.grey,
                                Colors.grey
                              ], // Replace with your desired colors
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.all(
                                Radius.circular(defaultPadding / 2)),
                          ),
                        ),

                        Container(
                          margin: const EdgeInsets.only(top: 15.0),
                          alignment: Alignment.center,
                          child: const Text(
                            tAppName,
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.deepOrange),
                          ),
                        ),
                        //   GradientContainer()
                      ]),
                )),
            Container(
              margin: const EdgeInsets.only(
                  top: 0.0, left: 0.0, bottom: 20.0, right: 0.0),
              alignment: Alignment.bottomCenter,
              child: const CircularProgressIndicator(
                  backgroundColor: Colors.deepOrange,
                  strokeWidth: 3,
                  color: Colors.purpleAccent),
            )
          ],
        ),
      ),
    );
  }
}

class GradientContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple,
            Colors.pink
          ], // Replace with your desired colors
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
