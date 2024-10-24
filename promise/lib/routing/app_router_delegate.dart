import 'dart:async';

import 'package:flutter/material.dart';
import 'package:promise/features/auth/router/auth_router.dart';
import 'package:promise/features/force_update/ui/force_update_page.dart';
import 'package:promise/features/home/router/home_router.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/user/user_credentials.dart';
import 'package:promise/routing/no_animation_transition_delegate.dart';
import 'package:promise/user/user_manager.dart';

import 'app_nav_state.dart';

/// Root rooter of this application
class AppRouterDelegate extends RouterDelegate
    with ChangeNotifier {

  StreamSubscription<UserCredentials?>? _userUpdatesSubscription;

  AppNavState _navState;
  bool _isUserLoggedIn = false;

  AppRouterDelegate(
    UserManager userManager, [
    this._navState = const AppNavState.auth(),
  ]) {
    Log.d('AppRouterDelegate - Subscribe to user updates');
    _userUpdatesSubscription = userManager.updatesSticky
        .distinct((prev, next) => _isUserLoggedIn == next?.isLoggedIn())
        .listen((usrCredentials) => onUserAuthenticationUpdate(usrCredentials));
  }

  @visibleForTesting
  void onUserAuthenticationUpdate(UserCredentials? usrCredentials) {
    Log.d('AppRouterDelegate - Credentials update: '
        '${usrCredentials.isLoggedIn() ? 'authorized' : 'unauthorized'}');
    _isUserLoggedIn = usrCredentials.isLoggedIn();
    _isUserLoggedIn ? setHomeNavState() : setAuthNavState();
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      transitionDelegate: NoAnimationTransitionDelegate(),
      key: UniqueKey(),
      pages: _getPages(),
      onDidRemovePage: (page){

      },
      onGenerateRoute: ROUTER_HANDLER,
    );
  }

  List<Page> _getPages() {
    if (_navState is AuthNavState) {
      return [
        const MaterialPage(
          key: ValueKey('AuthRouterPage'),
          child: AuthRouter(),
        )
      ];
    }

    if (_navState is ApplicationState) {
      return [
        MaterialPage(
          key: const ValueKey('HomeRouterPage'),
          child: HomeRouter(
             onBackPressed: () async {
              return false;
             },
          ),
        )
      ];
    }

    if (_navState is ForceUpdateNavState) {
      return [ForceUpdatePage()];
    }

    return [];
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }

  @override
  void dispose() async {
    super.dispose();
    Log.d('AppRouterDelegate - Unsubscribe from user updates');
    await _userUpdatesSubscription?.cancel();
  }

  void setForceUpdateNavState() {
    _navState = const AppNavState.forceUpdate();
    notifyListeners();
  }

  void setAuthNavState() {
    _navState = const AppNavState.auth();
    notifyListeners();
  }

  void setHomeNavState() {
    _navState = const AppNavState.home();
    notifyListeners();
  }
  
  @override
  Future<bool> popRoute() async {
    return true;
  }
}
