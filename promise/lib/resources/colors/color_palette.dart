import 'dart:core';

import 'package:flutter/material.dart';

class ColorPalette {
  // Light Theme
  static const Color primaryL = Color(0xFF6200EE);
  static const Color primaryDarkL = Color(0xFF3700B3);
  static const Color primaryLightL = Color(0xFF9E47FF);
  static const Color primaryDisabledL = Color(0x336200EE);
  static const Color accentL = Color(0xFF03DAC6);

  // Dark Theme
  static const Color primaryD = Color(0xFF121212);
  static const Color primaryDarkD = Color(0xFF000000);
  static const Color primaryLightD = Color(0xFF383838);
  static const Color primaryDisabledD = Color(0x33121212);
  static const Color accentD = Color(0xFFbb86fc);

  static const Color backgroundLightGreen = Color(0xFFE2F0F1);
  static const Color backgroundLightGray = Color(0xFFF5F5F5);
  static const Color backgroundGray = Color(0xFFD8D8D8);

  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color textGray = Color(0xFF8E9094);

  ColorPalette._();
}

Color colorFromHex(String code) {
  String colorString = code.replaceAll(RegExp('#'), '');
  return Color(int.parse(colorString, radix: 16) + 0xFF000000);
}
