import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loonaz_application/src/features/screens/splash_screen/splash_screen.dart';
import 'package:loonaz_application/src/utils/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme:TAppTheme.lightTheme,
     // darkTheme: TAppTheme.darkTheme,
     // themeMode: ThemeMode.system,
      home: SplashScreen(),
    );
  }
}
