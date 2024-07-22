import 'package:dio/dio.dart';

import '../authenticator/dio_authenticator_helper_jwt.dart';

/// [RequestInterceptor] that adds authorization header on each request.
class AuthInterceptor extends Interceptor {
  final AuthenticatorHelperJwt _authenticator;

  AuthInterceptor(this._authenticator);
  
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _authenticator.interceptRequest(options);
    handler.next(options);
  }
}
