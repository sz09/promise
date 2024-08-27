import 'package:flutter/widgets.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

extension Translate on BuildContext {
  String translate(String key) {
    try{
      return key.tr;
    } catch(r){
      return key;
    }
  }
}