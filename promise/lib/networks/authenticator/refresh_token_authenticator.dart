import 'dart:async';


import 'package:dio/dio.dart';
import 'dio_authenticator_helper_jwt.dart';

// import 'package:chopper/chopper.dart';
// import 'package:promise/network/chopper/authenticator/authenticator_helper_jwt.dart';

class RefreshTokenAuthenticator {
  final AuthenticatorHelperJwt _authenticator;

  RefreshTokenAuthenticator(this._authenticator);

  FutureOr<RequestOptions?> authenticate(RequestOptions request, Response<dynamic> response,
      [RequestOptions? originalRequest]) {
    return _authenticator
        .interceptResponse(request, response)
        .catchError((_) => null);
  }
}
