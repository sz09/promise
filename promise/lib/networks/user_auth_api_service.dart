import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/models/user/credentials.dart';

/// User re-authentication api service.
///
/// To obtain an instance use `serviceLocator.get<UserAuthApiService>()`
class UserAuthApiService {
  final DioClient client;
  static const String path = "/account";
  UserAuthApiService( {required this.client});

  /// Refresh token.
  Future<Credentials> refreshToken(String refreshToken) async {
    var response = await client.post<Credentials>("$path/refresh-token", {
      'token': refreshToken
    }, factoryMethod: Credentials.fromJson);

    return response.data!;
  }
}
