import 'package:flutter/material.dart';
import 'constants.dart';

/// 🔹 Light Theme
final ThemeData lightTheme = ThemeData(
  primaryColor: PRIMARY_COLOR,
  scaffoldBackgroundColor: BACKGROUND_COLOR,
  cardColor: CARD_COLOR,
  brightness: Brightness.light,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: PRIMARY_COLOR,
    foregroundColor: Colors.white,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: ACCENT_COLOR,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black87),
    headline2: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
    headline3: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
    bodyText1: TextStyle(fontSize: 16, color: Colors.black87),
    bodyText2: TextStyle(fontSize: 14, color: Colors.black54),
    caption: TextStyle(fontSize: 12, color: Colors.black45),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: PRIMARY_COLOR,
    thumbColor: PRIMARY_COLOR,
    overlayColor: PRIMARY_COLOR.withOpacity(0.2),
  ),
);

/// 🔹 Dark Theme
final ThemeData darkTheme = ThemeData(
  primaryColor: PRIMARY_COLOR,
  scaffoldBackgroundColor: Colors.black,
  cardColor: Colors.grey.shade900,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.black,
    foregroundColor: PRIMARY_COLOR,
    centerTitle: true,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: PRIMARY_COLOR,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: PRIMARY_COLOR,
    foregroundColor: Colors.white,
  ),
  textTheme: const TextTheme(
    headline1: TextStyle(
        fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: TextStyle(
        fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
    headline3: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
    bodyText1: TextStyle(fontSize: 16, color: Colors.white70),
    bodyText2: TextStyle(fontSize: 14, color: Colors.white60),
    caption: TextStyle(fontSize: 12, color: Colors.white38),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: ACCENT_COLOR,
    thumbColor: ACCENT_COLOR,
    overlayColor: ACCENT_COLOR.withOpacity(0.2),
  ),
);
