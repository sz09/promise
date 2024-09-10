import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:promise/config/network.const.dart';
import 'package:promise/networks/dio/dio.api.client.dart';
import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/networks/dio/dio.identity.client.dart';
import 'package:promise/networks/dio/dio.unauthorize.client.dart';
import 'package:promise/features/auth/user_api_service.dart';
import 'package:promise/features/force_update/force_update_handler.dart';
import 'package:promise/models/user/user_credentials.dart';
import 'package:promise/networks/user_auth_api_service.dart';
import 'package:promise/networks/authenticator/dio_authenticator_helper_jwt.dart';
import 'package:promise/user/unauthorized_user_handler.dart';
import 'package:single_item_storage/storage.dart';

/// Utility class for creating and configuring the API services.
class HttpApiServiceProvider {
  final DioClient _defaultClient;
  final DioClient _identityServerClient;
  final AuthenticatorHelperJwt _authenticatorHelper;

  factory HttpApiServiceProvider({
    required String baseUrl,
    required Storage<UserCredentials> userStore,
    http.Client? httpClient,
    PackageInfo? packageInfo,
    UnauthorizedUserHandler? unauthorizedUserHandler,
    ForceUpdateHandler? forceUpdateHandler,
  }) {
    unauthorizedUserHandler ??= UnauthorizedUserHandler(userStore);
    forceUpdateHandler ??= ForceUpdateHandler();
    DioClient unauthorizedClient = DioUnauthorizeClient(packageInfo, userStore);
    DioClient identityServerClient = DioIdentityServerClient(packageInfo, userStore);
    AuthenticatorHelperJwt authenticatorHelper = AuthenticatorHelperJwt(
      UserAuthApiService(
        client: identityServerClient
      ),
      userStore,
    );

    DioClient defaultClient = DioAPIClient(packageInfo, userStore, authenticatorHelper, API_VERSION);

    return HttpApiServiceProvider.withClients(defaultClient, unauthorizedClient,
        identityServerClient, authenticatorHelper);
  }

  HttpApiServiceProvider.withClients(
    DioClient defaultClient,
    DioClient unauthorizedClient,
    DioClient identityServerClient,
    this._authenticatorHelper,
  )   : _defaultClient = defaultClient,
        _identityServerClient = identityServerClient;

  /// Returns properly configured singleton UserAuthApiService.
  AuthenticatorHelperJwt getAuthHelperJwt() => _authenticatorHelper;

  /// Returns singleton UserAuthApiService.
  UserAuthApiService getUserAuthApiService() => UserAuthApiService(client: _identityServerClient);

  /// Returns singleton UserApiService.
  UserApiService getUserApiService() =>
      UserApiService(client: _identityServerClient);

  // /// Returns singleton TasksApiService.
  DioClient get apiClient => _defaultClient; 
}
