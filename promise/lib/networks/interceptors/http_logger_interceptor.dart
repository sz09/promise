import 'package:dio/dio.dart';
import 'package:promise/util/log/log.dart';

/// [HttpLoggingInterceptor] that uses [Log] instead of chopper logger.
class HttpLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // final base = await request.toBaseRequest();
    // Log.d('--> ${base.method} ${base.url}');
    // base.headers.forEach((k, v) => Log.d('$k: $v'));

    // var bytes = '';
    // if (base is http.Request) {
    //   final body = base.body;
    //   if (body.isNotEmpty) {
    //     Log.d(body);
    //     bytes = ' (${base.bodyBytes.length}-byte body)';
    //   }
    // }

    // Log.d('--> END ${base.method}$bytes');
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
