import 'package:bloc/bloc.dart';
import 'package:promise/app.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/user/user_manager.dart';

import 'login_state.dart';

export 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final UserManager userManager;

  LoginCubit(this.userManager) : super(AwaitUserInput());

  Future<void> onUserLogin(String username, String password) async {
    Log.d('LoginCubit - User login: username $username');
    try {
      await loadingOverlay.during(userManager.login(username, password));
      
    } catch (exp) {
      emit(LoginFailure(error: exp));
    }
  }
}
