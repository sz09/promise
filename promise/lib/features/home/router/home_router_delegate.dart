import 'package:flutter/material.dart';
import 'package:promise/app_1.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_nav_state.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  HomeRouterDelegate(this.navigatorKey,
      [this.appNavState = const AppNavState.application()]);

  AppNavState appNavState = const AppNavState.application();
  bool isSettingsShownState = false;
  bool isMemoryListShownState = false;

  // void setMemoryDetailNavState(Memory memory) {
  //   homeNavState = HomeNavState.memoryDetail(memory);
  //   notifyListeners();
  // }

  // void setIsSettingsShownState(bool isShown) {
  //   isSettingsShownState = isShown;
  //   notifyListeners();
  // }

  // void setIsMemoryListShownState(bool isShown) {
  //   isMemoryListShownState = isShown;
  //   notifyListeners();
  // }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        onGenerateRoute: ROUTER_HANDLER,
        pages: [
          const LoginPage1(),
          if(appNavState is ApplicationState) ApplicationLayout1()
          // TimelinePage1(),
          // if (homeNavState is MemoryDetailNavState)
          //    MemoryDetailPage(task: (homeNavState as MemoryDetailNavState).memory),
          // if (isSettingsShownState) SettingsPage(),
          // if (isMemoryListShownState) MemoryListPage()
        ],
        onPopPage: (route, result) {
          if (isSettingsShownState) isSettingsShownState = false;
          appNavState = const AppNavState.application();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
