import 'dart:async';
import 'package:dio/dio.dart' show RequestOptions, Response;
import 'package:promise/config/network.const.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/user/credentials.dart';
import 'package:promise/models/user/refresh_token.dart';
import 'package:promise/models/user/user_credentials.dart';
import 'package:promise/networks/user_auth_api_service.dart';
import 'package:promise/user/unauthorized_user_exception.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:promise/util/http_exception_code.dart';
import 'package:promise/util/http_util.dart';
import 'package:promise/util/network_utils.dart';
import 'package:single_item_storage/storage.dart';
import 'package:synchronized/synchronized.dart';


/// Detects 401 response code and attempts to re-authenticate the user.
///
/// If the user is unauthorized this component will only throw
/// `UnauthorizedUserException` without any additional handling.
///
/// To obtain an instance use `serviceLocator.get<AuthenticatorHelperJwt>()`
class AuthenticatorHelperJwt {
  static final Lock _lock = Lock();

  final UserAuthApiService _userAuthApiService;
  final Storage<UserCredentials> _userStore;

  AuthenticatorHelperJwt(this._userAuthApiService, this._userStore);

  /// Checks if the token is expired using the expiry token data
  /// and refreshes it if necessary.
  ///
  /// Use this to manually check and refresh the token.
  /// If the user is unauthorized you have to manually handle the case.
  ///
  /// Returns a valid token - the new one if refreshed, the current one
  /// if it's valid, or else Exception.
  ///
  /// Throws error if the token is expired or doesn't exist and the
  /// refresh failed.
  ///
  /// Will return `UnauthorizedUserException` only when we're sure the
  /// refresh token is expired, otherwise it's a different exception.
  ///
  /// If `onError` is provided, the exception is not thrown but
  /// is replaced with the `onError` result.
  Future<String?> refreshIfTokenExpired({
    Credentials? credentials,
    String? Function(dynamic error)? onError,
  }) {
    Log.d('Authenticator (manual) - Manual token check');
    return _lock.synchronized<String?>(() async {
      Log.d('Authenticator (manual) - lock');

      // Get current token
      final UserCredentials? loggedInUser = await _userStore.get();
      final Credentials? currentUser = credentials ?? loggedInUser?.credentials;
      final String? currentToken = currentUser?.token;

      // Throw if a token does not exist
      if (currentToken == null) {
        Log.e('Authenticator (manual) - Token does not exist');
        throw Exception('Token does not exist');
      }

      // Check if token is expired
      bool isTokenExpired = JwtDecoder.isExpired(currentToken);
      if (isTokenExpired) {
        Log.d('Authenticator (manual) - Token expired');

        // Check if refresh token is expired
        _ensureRefreshTokenNotExpired(currentUser?.refreshToken);

        // Refresh the token
        Log.d('Authenticator (manual) - Refreshing token...');
        final newCredentials = await _refreshToken(currentUser!.refreshToken);

        // Token refresh success. Save new token, update interceptor.
        Log.d('Authenticator (manual) - Updating old token');
        await _userStore.save(loggedInUser!.copy(cred: newCredentials));

        return newCredentials.token;
      } else {
        Log.d('Authenticator (manual) - Token is not expired');
        return currentToken;
      }
    }, timeout: const Duration(seconds: 30)).catchError((e) => onError!.call(e),
        test: (error) {
      Log.e('Authenticator (manual) - Exception thrown: $error');
      return onError != null;
    }).whenComplete(() {
      Log.d('Authenticator (manual) - lock released');
    });
  }

  /// Intercepts a network response and if status code is 401 refreshes
  /// the token returning `null` if no action was done, or new [RequestOptions]
  /// with hopefully new and correct credentials.
  Future<RequestOptions?> interceptResponse(RequestOptions request, Response response) async {
    // Handle only 401 unauthorized requests
    if (response.statusCode != 401) {
      return null;
    }
    Log.d('Authenticator (response) - '
        'Handling 401 unauthorized request: ${request.path}');

    // Check current token
    final String? tokenUsed =
        request.headers[authHeaderKey]?.substring('Bearer '.length);
    if (tokenUsed == null) {
      // throw UnauthorizedUserException('RequestOptions w/o token - '
      //     'response reason: ${response.base.reasonPhrase} \n'
      //     'url: ${request.url} \n');
      // TODO: extract response.base.reasonPhrase
      throw UnauthorizedUserException('RequestOptions w/o token - '
          'response reason: ${'dadadadadadada'} \n'
          'url: ${request.path} \n');
      
    }

    final RequestOptions? newRequestOptionsMaybe = await _lock.synchronized<RequestOptions?>(
      () async {
        Log.d('Authenticator (response) - lock');

        // Check if a newer token exists than our current one
        final UserCredentials? loggedInUser = await _userStore.get();
        final Credentials? currentUser = loggedInUser?.credentials;
        final String? tokenCurrent = currentUser?.token;

        if (tokenCurrent == null) {
          Log.e('Authenticator (response) - User logged out!');
          throw UnauthorizedUserException('User logged out!');
        }
        if (tokenCurrent != tokenUsed) {
          Log.d('Authenticator (response) - Refreshed token exists'
              '\nnewToken: $tokenCurrent'
              '\nusedToken: $tokenUsed');
          return applyHeader(request, authHeaderKey, tokenCurrent);
        }

        // Check if refresh token is expired
        _ensureRefreshTokenNotExpired(currentUser?.refreshToken);

        // Refresh the token
        Log.d('Authenticator (response) - Refreshing token...');
        final newCredentials = await _refreshToken(currentUser!.refreshToken);

        // Token refresh success. Save new token, update interceptor.
        Log.d('Authenticator (response) - Token refresh success; Saving...');
        await _userStore.save(loggedInUser!.copy(cred: newCredentials));

        Log.d('Authenticator (response) - releasing lock');

        return applyHeader(request, authHeaderKey, newCredentials.token);
      },
      timeout: const Duration(seconds: 30),
    // ignore: body_might_complete_normally_catch_error
    ).catchError((_) {}, test: (error) {
      Log.e('Authenticator (response) - Exception thrown: $error');
      return false;
    }); //lock end
    Log.d('Authenticator (response) - lock released');
    return newRequestOptionsMaybe;
  }

  /// Intercepts a network request before it's sent and refreshes the token if expired.
  Future<RequestOptions> interceptRequest(RequestOptions request) async {
    // Check used token, if any
    final String? tokenUsed =
        request.headers[authHeaderKey]?.substring('Bearer '.length);

    // Check if any used token is valid
    if (tokenUsed != null && !JwtDecoder.isExpired(tokenUsed)) {
      Log.d('Authenticator (request) - Token is valid');
      return request;
    }

    final RequestOptions newRequestOptionsMaybe = await _lock.synchronized(
      () async {
        Log.d('Authenticator (request) - lock');

        // Apply token to the request, if not expired
        final UserCredentials? loggedInUser = await _userStore.get();
        final Credentials? currentUser = loggedInUser?.credentials;
        final String? tokenCurrent = currentUser?.token;
        if (tokenCurrent == null) {
          Log.d('Authenticator (request) - RequestOptions w/o token: $request');
          return request;
        }
        if (!JwtDecoder.isExpired(tokenCurrent)) {
          Log.d('Authenticator (request) - Applying token'
              '\nnewToken: $tokenCurrent'
              '\nusedToken: $tokenUsed');
          return applyHeader(
            request,
            authHeaderKey,
            authHeaderValue(tokenCurrent)
          );
        }

        // Check if refresh token is expired
        _ensureRefreshTokenNotExpired(currentUser?.refreshToken);

        // Refresh the token
        Log.d('Authenticator (request) - Refreshing token...');
        final newCredentials = await _refreshToken(currentUser!.refreshToken);

        Log.d('Authenticator (request) - Token refresh success');
        await _userStore.save(loggedInUser!.copy(cred: newCredentials));

        Log.d('Authenticator (request) - Swapping old token');
        Log.d('Authenticator (request) - releasing lock');

        return applyHeader(
          request,
          authHeaderKey,
          authHeaderValue(newCredentials.token)
        );
      },
      timeout: const Duration(seconds: TIMEOUT),
    // ignore: body_might_complete_normally_catch_error
    ).catchError((_) {}, test: (error) {
      Log.e('Authenticator (request) - Exception thrown: $error');
      return false;
    });

    Log.d('Authenticator (request) - lock released');
    return newRequestOptionsMaybe;
  }

  void _ensureRefreshTokenNotExpired(RefreshToken? refreshToken) {
    final int now = DateTime.now().millisecondsSinceEpoch;
    if (refreshToken == null || refreshToken.expiresAt < now) {
      Log.d('Authenticator (n/a) - Refresh token is expired!');
      throw UnauthorizedUserException('Refresh token expired! '
          '(token expiry time: ${refreshToken?.expiresAt}, '
          '(now: $now)');
    }
  }

  Future<Credentials> _refreshToken(RefreshToken refreshToken) async {
    final Credentials newCredentials = await _userAuthApiService
        .refreshToken(refreshToken.token)
        .timeout(const Duration(seconds: TIMEOUT))
        .catchError(
      // ignore: cast_from_null_always_fails
      (_) => Future.value(null as Credentials),
      test: (error) {
        // Errors getting result, even negative, will be propagated.
        // This is to prmemory unnecessarily logging out the user (app offline, etc.)
        Log.e('Authenticator (n/a) - Refresh token failed: $error');
        return error is UnauthorizedUserException ||
            (error is HttpExceptionCode &&
                (error.statusCode ?? 0) >= 400 &&
                (error.statusCode ?? 0) < 500);
      },
    );

    // Token refresh refused
    // ignore: unnecessary_null_comparison
    if (newCredentials == null) {
      Log.e('Authenticator (n/a) - Unsuccessful token refresh');
      throw UnauthorizedUserException('Refresh token refused');
    }

    return newCredentials;
  }
}
