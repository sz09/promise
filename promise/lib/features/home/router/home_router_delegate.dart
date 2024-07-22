import 'package:flutter/material.dart';
import 'package:promise/app_1.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/home/router/home_nav_state.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';
import 'package:promise/models/memory/memory.dart';

class HomeRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> navigatorKey;

  HomeRouterDelegate(this.navigatorKey,
      [this.homeNavState = const HomeNavState.memoryList()]);

  HomeNavState homeNavState = const HomeNavState.memoryList();
  bool isSettingsShownState = false;
  bool isMemoryListShownState = false;

  void setMemoryDetailNavState(Memory memory) {
    homeNavState = HomeNavState.memoryDetail(memory);
    notifyListeners();
  }

  void setIsSettingsShownState(bool isShown) {
    isSettingsShownState = isShown;
    notifyListeners();
  }

  void setIsMemoryListShownState(bool isShown) {
    isMemoryListShownState = isShown;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: navigatorKey,
        pages: const [
          LoginPage1(),
          // TimelinePage1(),
          // if (homeNavState is MemoryDetailNavState)
          //    MemoryDetailPage(task: (homeNavState as MemoryDetailNavState).memory),
          // if (isSettingsShownState) SettingsPage(),
          // if (isMemoryListShownState) MemoryListPage()
        ],
        onPopPage: (route, result) {
          if (isSettingsShownState) isSettingsShownState = false;
          homeNavState = const HomeNavState.memoryList();
          return route.didPop(result);
        });
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    /* no-op */
  }
}
