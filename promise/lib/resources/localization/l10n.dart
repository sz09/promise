// ignore_for_file: constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';

const EN = Locale('en');
const MK = Locale('mk');

class L10n {
  static Locale getLocale(String code) {
    switch (code) {
      case 'mk':
        return MK;
      case 'en':
      default:
        return EN;
    }
  }
}
