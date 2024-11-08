import 'package:flutter/material.dart';
import 'package:promise/application_layout_widget.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/people/ui/people_page.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/ui/list/promise_list_page.dart';
import 'package:promise/features/settings/ui/settings_page.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_nav_state.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier {
  final Future<bool> Function() onBackPressed;

  HomeRouterDelegate(
      {
        required this.onBackPressed,
        this.appNavState = const AppNavState.home()
      }) {
        // navigatorKey = UniqueKey<NavigatorState>();
      }

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
    notifyListeners();
  }
  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: UniqueKey(),
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
                      widgetKey: 'layout.promise_title',
                      child: PromiseListPage()));
            case memoriesRoute:
              return MaterialPageRoute(
                  builder: (context) => ApplicationLayout(
                      widgetKey: 'layout.memory_title',
                      child: const MemoryListPage()));
            case peopleRoute:
              return MaterialPageRoute(
                  builder: (context) => ApplicationLayout(
                      widgetKey: 'layout.people_title',
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
  

  @override
  Future<bool> popRoute() {
    return onBackPressed();
  }
}
