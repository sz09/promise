import 'package:flutter/material.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/auth/router/auth_nav_state.dart';
import 'package:promise/features/auth/signup/ui/password/password_page.dart';
import 'package:promise/features/auth/signup/ui/username/username_page.dart';
import 'package:promise/util/log/log.dart';

class AuthRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  AuthNavState _authNavState;

  AuthRouterDelegate(this.navigatorKey,
      [this._authNavState = const AuthNavState.login()]);

  void setLoginNavState() {
    _authNavState = const AuthNavState.login();
    notifyListeners();
  }

  void setSignupUsernameNavState() {
    _authNavState = AuthNavState.signupUsername(_authNavState);
    notifyListeners();
  }

  void setSignupPasswordNavState() {
    _authNavState = AuthNavState.signupPassword(_authNavState);
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    Log.d('AuthRouterDelegate build ${context.widget}');
    return Navigator(
        key: navigatorKey,
        pages: [
          const LoginPage1(),
          if (_authNavState is SignupUsernameNavState) UsernamePage(),
          if (_authNavState is SignupPasswordNavState) ...[
            UsernamePage(),
            PasswordPage()
          ],
        ],
        onPopPage: (route, result) {
          _authNavState = _authNavState.prevState ?? const AuthNavState.login();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
