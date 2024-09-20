import 'dart:io';

import 'package:dio/dio.dart';
import 'package:promise/pre_app_config.dart';
import 'package:promise/util/network_utils.dart';

/// [RequestInterceptor] that adds preferred language header on each request.
class LanguageInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
     final String? locale = getStorage.read<String>(languageCode);
    if (locale != null) {
      applyHeader(options, HttpHeaders.acceptLanguageHeader, locale);
    } 
    handler.next(options);
  }
}
