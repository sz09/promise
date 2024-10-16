import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/models/user/credentials.dart';
import 'package:promise/models/user/register_user/register_user.dart';
import 'package:promise/models/user/user.dart';

class UserApiService {
  final DioClient client;
  static const String account = '/account';

  UserApiService({required this.client});

  /// Registers a user
  Future<void> signUp(RegisterUser user) async {
     await client.post('$account/signup', user, factoryMethod: RegisterUser.fromJson);
  }

  /// Gets the logged in user
  Future<Credentials> login(String username, String password) async {
    final response = await client.post('$account/login', {
      'username': username,
      'password': password
    }, factoryMethod: Credentials.fromJson);
    return response.data!;
  }
}

class AuthrizeUserApiService {

  final DioClient client;
  static const String account = '/account';

  AuthrizeUserApiService({required this.client});

  /// Returns user profile details
  Future<IdentityUser> getUserProfile({String? authHeader}) async {
    final response = await client.get<IdentityUser>('$account/profile', {
      'authHeader': authHeader
    });
    return response.data!;
  }

  /// Updates user profile details
  Future<IdentityUser> updateUserProfile(IdentityUser user) async {
    final response = await client.put<IdentityUser>('$account/profile', user);
    return response.data!;
  }

  /// Sends a request for resetting the user's password
  Future<void> resetPassword(String email) async {
    await client.put<IdentityUser>('$account/reset-password', {
      email: email
    });
  }

  /// Adds token needed for logged in user to receive push notifications
  Future<void> addNotificationsToken(String token) async {
    await client.post('$account/add-notification-token', {
      'token': token
    });
  }

  /// Logs out the user from server
  Future<void> logout() async {
    // await client.post('$account/logout', null);
  }

  /// Deactivates the user
  Future<void> deactivate() async {
     await client.post('$account/deactive', null);
  }
}
