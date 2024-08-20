// ignore_for_file: constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

const EN = Locale('en');
const VN = Locale('vi', "VN");

class L10n {
  static Locale getLocale(String code) {
    switch (code) {
      case 'vi':
        return VN;
      case 'en':
      default:
        return EN;
    }
  }
}
