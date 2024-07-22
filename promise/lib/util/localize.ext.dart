import 'package:flutter/widgets.dart';
import 'package:promise/app_localization.dart';

extension Translate on BuildContext {
  String translate(String key) {
    try{
      return AppLocalization.of(this).getTranslatedValue(key).toString();
    } catch(r){
      return key;
    }
  }
}