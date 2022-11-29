import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color primaryColor = const Color(0xff15A62C);
Color subtitleColor = const Color(0xff8789A3);
Color titleColor = const Color(0xff240F4F);
Color whiteColor = Colors.white;
Color darkColor = const Color(0xff023020);

TextStyle primaryTextStyle = GoogleFonts.poppins(
  // color: primaryColor,
  fontSize: 14,
  fontWeight: regular,
);

TextStyle subtitleTextStyle = GoogleFonts.poppins(
  color: subtitleColor,
  fontSize: 14,
  fontWeight: regular,
);

TextStyle titleTextStyle = GoogleFonts.poppins(
  // color: titleColor,
  fontSize: 14,
  fontWeight: regular,
);

TextStyle whiteTextStyle = GoogleFonts.poppins(
  color: whiteColor,
  fontSize: 14,
  fontWeight: regular,
);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

double defaultMargin = 24;

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkColor,
    scaffoldBackgroundColor: darkColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColor,
      titleTextStyle: primaryTextStyle.copyWith(
        color: whiteColor,
      ),
      foregroundColor: whiteColor,
    ),
    listTileTheme: ListTileThemeData(
      textColor: whiteColor,
    ));
ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: whiteColor,
    scaffoldBackgroundColor: whiteColor,
    appBarTheme: AppBarTheme(
      backgroundColor: whiteColor,
      titleTextStyle: primaryTextStyle.copyWith(
        color: primaryColor,
      ),
      foregroundColor: primaryColor,

    ),
    listTileTheme: ListTileThemeData(
      textColor: primaryColor,
    ));
