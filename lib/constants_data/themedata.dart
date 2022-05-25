import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:securemsg/constants_data/ui_constants.dart';

class ThemeClass {
  static ThemeData lightTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.deepPurpleAccent,
      ));

  static ThemeData darkTheme = ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.dark(),
      textTheme: GoogleFonts.balsamiqSansTextTheme(TextTheme(
          bodyText1: TextStyle(color: kdefualtfontcolor.withOpacity(0.9)))),
      appBarTheme: AppBarTheme(
        textTheme: GoogleFonts.balsamiqSansTextTheme(TextTheme(
            bodyText1: TextStyle(color: kdefualtfontcolor.withOpacity(0.9)))),
        backgroundColor: Colors.black,
      ));
}
