import 'package:flutter/material.dart';
import 'package:totranslate/lang.dart';

class Themes {
  static final lightTheme = ThemeData.light().copyWith(
      backgroundColor: Colors.white,
      // textTheme: const TextTheme(
      //   subtitle1: TextStyle(fontSize: 14.0, fontFamily: 'Vietnam'),
      //   bodyText1: TextStyle(
      //       fontSize: 14.0, fontFamily: 'Vietnam', color: Colors.black),
      //   bodyText2: TextStyle(
      //       fontSize: 14.0, fontFamily: 'Vietnam', color: Colors.black),
      // ),
      iconTheme: const IconThemeData(color: Lang.themeColor));
  static final darkTheme = ThemeData.dark().copyWith(
      backgroundColor: Colors.black,
      // textTheme: const TextTheme(
      //   subtitle1: TextStyle(fontSize: 14.0, fontFamily: 'Vietnam'),
      //   bodyText1: TextStyle(
      //       fontSize: 14.0, fontFamily: 'Vietnam', color: Colors.white),
      //   bodyText2: TextStyle(
      //       fontSize: 14.0, fontFamily: 'Vietnam', color: Colors.white),
      // ),
      iconTheme: const IconThemeData(color: Lang.themeColor));
}
