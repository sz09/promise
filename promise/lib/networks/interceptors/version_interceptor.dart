import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:promise/util/http_util.dart';
import 'package:promise/util/network_utils.dart';

/// [RequestInterceptor] that adds the supported app version header on each request.
class VersionInterceptor extends Interceptor {
  final PackageInfo? _packageInfo;

  VersionInterceptor([this._packageInfo]);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_packageInfo != null) {
      applyHeader(
        options,
        versionHeaderKey,
        headerAppVersionValue(_packageInfo),
      );
    }

    handler.next(options);
  }
}
