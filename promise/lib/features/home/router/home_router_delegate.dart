import 'package:flutter/material.dart';
import 'package:promise/application_layout.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/ui/promise_list_page.dart';
import 'package:promise/features/settings/ui/settings_page.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_nav_state.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
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

  final memoryListPage = ApplicationLayout(widgetKey: 'memory.title', child: const MemoryListPage());
  final promiseListPage = ApplicationLayout(widgetKey: 'promise.title', child: const PromiseListPage());
  final timelinePage = ApplicationLayout(widgetKey: 'timeline.title', child: const TimelinePage());
  final settingPage = const SettingsPage();
  @override
  Widget build(BuildContext context) {
  final List<Page<void>> pages = <Page<void>>[
    timelinePage,
    memoryListPage,
    promiseListPage
  ];
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        switch (settings.name) { 
          case loginRoute:
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/':
            return MaterialPageRoute(builder: (context) => pages[0]) ;
            break;
          case promisesRoute:
            pages.add(promiseListPage);
            notifyListeners();
            break;
          case memoriesRoute:
            pages.add(promiseListPage);
            notifyListeners();
            break;
          case settingsRoute:
            pages.add(settingPage);
            notifyListeners();
            break;
          default:
            // page = const NotFoundScreen();
            throw Exception('not support');
        }
      },
      pages: pages,
      onUnknownRoute: (settings) {

      },

      onDidRemovePage:(page){
        if(isSettingsShownState){
          pages.add(settingPage);
        }
        pages.remove(page);
      });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
