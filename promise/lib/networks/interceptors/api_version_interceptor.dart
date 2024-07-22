import 'package:dio/dio.dart';

/// [RequestInterceptor] that adds the supported app version header on each request.
class APIVersionInterceptor extends Interceptor {
  final int apiVersion;

  APIVersionInterceptor({required this.apiVersion});
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final oldPath = options.path;
    options.path = '/api/v$apiVersion$oldPath';
    handler.next(options);
  }
}
