import 'package:flutter/material.dart';
import 'package:promise/application_layout_widget.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/people/ui/people_page.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/ui/promise_list_page.dart';
import 'package:promise/features/settings/ui/settings_page.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_nav_state.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  HomeRouterDelegate(this.navigatorKey,
      [this.appNavState = const AppNavState.home()]);

  AppNavState appNavState = const AppNavState.home();
  bool isSettingsShownState = false;

  bool setIsSettingsShownState(bool isShown) {
    isSettingsShownState = isShown;
    // if(isShown){
    //     pages.add(promiseListPage);
    // }
    notifyListeners();
    return false;
  }

  bool canSetApplicationState({required ApplicationState appState}) {
    return appNavState != appState;
  }

  void setApplicationState({required ApplicationState appState}) {
    appNavState = appState;
    // switch(appState) {
    //   case MemoryListState _:
    //     pages.add(memoryListPage);
    //   case PromiseListState _:
    //     pages.add(promiseListPage);
    // }
    notifyListeners();
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case loginRoute:
              return MaterialPageRoute(builder: (context) => const LoginWidget());
            case homeRoute:
              return MaterialPageRoute(
                  builder: (context) => ApplicationLayout(
                      widgetKey: 'timeline.title',
                      child: const TimelinePage()));
            case promisesRoute:
              return MaterialPageRoute(
                  builder: (context) => ApplicationLayout(
                      widgetKey: 'promise.title',
                      child: const PromiseListPage()));
            case memoriesRoute:
              return MaterialPageRoute(
                  builder: (context) => ApplicationLayout(
                      widgetKey: 'memory.title',
                      child: const MemoryListPage()));
            case peopleRoute:
              return MaterialPageRoute(
                  builder: (context) => ApplicationLayout(
                      widgetKey: 'people.title',
                      child: const PeoplePage()));
            case settingsRoute:
              return MaterialPageRoute(
                  builder: (context) => const SettingsWidget());
            default:
              throw Exception('not support');
          }
        },
        onDidRemovePage: (page) {
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
