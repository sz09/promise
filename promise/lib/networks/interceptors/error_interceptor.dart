import 'package:dio/dio.dart';
import 'package:promise/features/force_update/force_update_handler.dart';
import 'package:promise/user/unauthorized_user_handler.dart';
import 'package:promise/util/log/log.dart';

/// [RequestInterceptor] that parses errors.
class ErrorInterceptor extends Interceptor {
  final UnauthorizedUserHandler _unauthorizedUserHandler;
  // ignore: unused_field
  final ForceUpdateHandler _forceUpdateHandler;

  ErrorInterceptor(this._unauthorizedUserHandler, this._forceUpdateHandler);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // todo modify when implementing force update
    // if (response.statusCode == 412) {
    //   _forceUpdateHandler.onForceUpdateEvent();
    //   throw ForceUpdateException(response.base.reasonPhrase);
    // }
    // Unauthorized user after failed refresh token attempt
    if (response.statusCode == 401) {
      _unauthorizedUserHandler.onUnauthorizedUserEvent();
    } else if (response.statusCode == 500) {
      Log.e('[Error interceptor] [${response.realUri.path}] [status code: ${response.statusCode}] [error: Server error: ${response.data['error']}]');
      var error = DioException.badResponse(
        statusCode: response.statusCode!,
        requestOptions: response.requestOptions,
        response: response,
      );
      handler.reject(error);
    } 
    else if(response.statusCode == 304 || response.statusCode == 404){
      response.data = null;
      handler.next(response);
    } 
    else {
      handler.next(response);
    }
  }
}
