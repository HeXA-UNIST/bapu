import 'package:flutter/material.dart';

final ThemeData customTheme = ThemeData(
  fontFamily: "Spoqa",
  primaryColor: const Color(0xFF00CD80),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: const Color.fromRGBO(0, 205, 128, 1),
    secondary: const Color.fromRGBO(0, 205, 128, 1),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    centerTitle: false,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.black,
      fontSize: 20,
      fontFamily: "Spoqa",
    ),
  ),
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.only(left: 40),
    minLeadingWidth: 5,
    dense: false,
    iconColor: Colors.white,
    textColor: Colors.white,
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontFamily: "Spoqa",
      fontWeight: FontWeight.w800,
    ),
  ),
  dialogTheme: DialogTheme(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    elevation: 0,
  ),
);
