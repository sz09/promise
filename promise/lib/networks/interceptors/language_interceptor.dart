import 'dart:io';

import 'package:dio/dio.dart';
import 'package:promise/util/network_utils.dart';
import 'package:single_item_storage/storage.dart';

/// [RequestInterceptor] that adds preferred language header on each request.
class LanguageInterceptor extends Interceptor {
  final Storage<String> _localeStore;

  LanguageInterceptor(this._localeStore);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
     final String? locale = await _localeStore.get();
    if (locale != null) {
      applyHeader(options, HttpHeaders.acceptLanguageHeader, locale);
    } 
    handler.next(options);
  }
}
