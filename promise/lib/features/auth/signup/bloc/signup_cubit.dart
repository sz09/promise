import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:promise/features/auth/user_api_service.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/user/register_user/register_user.dart';
import 'package:promise/user/user_manager.dart';

import 'signup_state.dart';

export 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final UserApiService apiService;
  final UserManager userManager;

  String? _username;
  String? _email;
  String? _password;

  SignupCubit(this.apiService, this.userManager)
      : super(AwaitUsernameInput('', ''));

  Future<void> onUsernameEntered(String username, String email) async {
    Log.d('SignUpCubit - User sign up: username $username');
    _username = username;
    _email = email;
    emit(AwaitPasswordInput(username, email));
  }

  Future<void> onPasswordEntered(String password) async {
    Log.d('SignUpCubit - User sign up: username $password');
    _password = password;
  }

  Future<void> onUserSignup() async {
    Log.d('SignUpCubit - User sign up: username $_username');
    Log.d('SignUpCubit - User sign up: email $_email');
    Log.d('SignUpCubit - User sign up: password $_password');

    emit(SignupInProgress());
    final RegisterUser user = RegisterUser(id: "id", email: _email!, username: _username!, password: _password!);

    await apiService
        .signUp(user)
        .then((_) => userManager.login(_username!, _password!));
    emit(SignupSuccess());
  }
}
