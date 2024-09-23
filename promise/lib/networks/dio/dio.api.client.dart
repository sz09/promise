import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/network.const.dart';
import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/features/force_update/force_update_handler.dart';
import 'package:promise/models/user/user_credentials.dart';
import 'package:promise/networks/authenticator/dio_authenticator_helper_jwt.dart';
import 'package:promise/networks/interceptors/api_version_interceptor.dart';
import 'package:promise/networks/interceptors/auth_interceptor.dart';
import 'package:promise/networks/interceptors/error_interceptor.dart';
import 'package:promise/networks/interceptors/http_logger_interceptor.dart';
import 'package:promise/networks/interceptors/language_interceptor.dart';
import 'package:promise/networks/interceptors/version_interceptor.dart';
import 'package:promise/user/unauthorized_user_handler.dart';
import 'package:promise/util/http_util.dart';
import 'package:single_item_storage/storage.dart';

class DioAPIClient extends DioClient{ 

  DioAPIClient(
    PackageInfo? packageInfo,
    Storage<UserCredentials> userStore,
    AuthenticatorHelperJwt authenticatorHelper,
    int apiVersion){
    BaseOptions options = BaseOptions(
      baseUrl: FlavorConfig.values.baseUrlApi,
      contentType: headerContentTypeJson.value,
      validateStatus: (int? status) {
        return status != null;
      },
      connectTimeout: const Duration(seconds: CONNECT_TIMEOUT),
      receiveTimeout: const Duration(seconds: TIMEOUT),
      headers: {
        'Cache-Control': 'no-cache',
        headerContentTypeJson.key: headerContentTypeJson.value
      },
      //contentType: 'application/json; charset=utf-8',

      responseType: ResponseType.json
    );
    final dio  = Dio(options);
    dio.interceptors.addAll(
      [
        AuthInterceptor(authenticatorHelper),
        APIVersionInterceptor(apiVersion: apiVersion),
        // JsonResponseConverter(),
        VersionInterceptor(packageInfo),
        LanguageInterceptor(),
        HttpLoggerInterceptor(),
        ErrorInterceptor(
          UnauthorizedUserHandler(userStore),
          ForceUpdateHandler(),
        )
      ]
    );
    client = dio;
  }
}