import 'package:dio/dio.dart';
import 'package:promise/util/log/log.dart';

/// [HttpLoggingInterceptor] that uses [Log] instead of chopper logger.
class HttpLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    Log.d('HTTP LOGGER: --> ${options.method} ${options.path}');
    // options.headers.forEach((k, v) => Log.d('$k: $v'));

    var bytes = '';

    // if (options.data != null) {
    //   final body = options.data;
    //   if (body.isNotEmpty) {
    //     // Log.d(body);
    //     // bytes = ' (${options}-byte body)';
    //   }
    // }

    Log.d('--> END ${options.method}$bytes');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // final base = response.base.request;
    // Log.d('<-- ${response.statusCode} ${base!.url}');

    // response.base.headers.forEach((k, v) => Log.d('$k: $v'));

    // var bytes;
    // if (response.base is http.Response) {
    //   final resp = response.base as http.Response;
    //   if (resp.body.isNotEmpty) {
    //     Log.d(resp.body);
    //     bytes = ' (${response.bodyBytes.length}-byte body)';
    //   }
    // }

    // Log.d('--> END ${base.method}$bytes');

    handler.next(response);
  }
}
