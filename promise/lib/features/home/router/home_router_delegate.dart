import 'package:flutter/material.dart';
import 'package:promise/application_layout.dart';
import 'package:promise/features/memory/bloc/memory_list_state.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/bloc/promise_list_state.dart';
import 'package:promise/features/promise/ui/promise_list_page.dart';
import 'package:promise/features/settings/ui/settings_page.dart';
import 'package:promise/features/timeline/bloc/timeline_bloc.dart';
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
        key: navigatorKey,
        onGenerateRoute: ROUTER_HANDLER,
        pages: [
          if(appNavState is MemoryListShowState) ApplicationLayout(widgetKey: 'memory.title', child: const MemoryListPage())
          else if(appNavState is PromiseListShowState) ApplicationLayout(widgetKey: 'promise.title', child: const PromiseListPage())
          else if(appNavState is ApplicationState || appNavState is TimelineState) ApplicationLayout(widgetKey: 'timeline.title', child: const TimelinePage()),

          if (isSettingsShownState) const SettingsPage()
        ],
        onPopPage: (route, result) {
          if(isSettingsShownState) isSettingsShownState = false;
          var x = route.didPop(result);
          return x;
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
