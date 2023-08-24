import 'package:flutter/material.dart';
import 'package:loonaz_application/src/utils/theme/widget_themes/text_theme.dart';

class TAppTheme {
   static ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      textTheme: TTextTheme.lightTextTheme
   );
   static ThemeData darkTheme = ThemeData(
       brightness: Brightness.dark,
       textTheme: TTextTheme.darkTextTheme
   );
}