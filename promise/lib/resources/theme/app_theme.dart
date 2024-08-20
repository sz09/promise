import 'package:flutter/material.dart';
import '../colors/color_palette.dart';

extension on ThemeData {
  ThemeData setCommonThemeElements() => copyWith(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      );
}

ThemeData themeLight() => ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorPalette.primaryL,
    scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
    cardColor: ColorPalette.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        // primary: ColorPalette.black,
        backgroundColor: ColorPalette.accentL,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          //primary: ColorPalette.accentL,
          ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color.fromARGB(255, 255, 255, 255),
      ),
    )).setCommonThemeElements();

ThemeData themeDark() => ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorPalette.primaryD,
    //accentColor: ColorPalette.accentD,
    scaffoldBackgroundColor: const Color.fromARGB(0, 0, 0, 0),
    cardColor: ColorPalette.primaryDisabledD,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
        // primary: ColorPalette.black,
        backgroundColor: ColorPalette.accentD,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          //primary: ColorPalette.accentD,
          ),
    ),
    textTheme: const TextTheme(
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        color: ColorPalette.white,
      ),
    )).setCommonThemeElements();
