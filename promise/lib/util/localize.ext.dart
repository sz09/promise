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

extension XX on String {
  String translateAndReplace(Map<String, dynamic> params){
    try{
      // ignore: unnecessary_this
      var translatedValue = this.tr;
      for(var param in params.entries) {
        translatedValue = translatedValue.replaceAll("{{${param.key}}}", param.value);
      }
      return translatedValue;
    } catch(r){
      return this;
    }
  }
}