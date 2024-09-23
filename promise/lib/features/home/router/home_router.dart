import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:promise/features/home/router/home_router_delegate.dart';
import 'package:provider/provider.dart';

/// Nested router that hosts all task screens and manages navigation among them.
class HomeRouter extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final Future<bool> Function() onBackPressed;

  const HomeRouter(this.navigatorKey, {super.key, required this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    final childBackButtonDispatcher =
        ChildBackButtonDispatcher(Router.of(context).backButtonDispatcher!)
          ..takePriority();

    return ChangeNotifierProvider<HomeRouterDelegate>(
        create: (_) {
          var x = HomeRouterDelegate(navigatorKey, onBackPressed: onBackPressed);
          Get.routerDelegate = x;
          return x;
        },
        child: Consumer<HomeRouterDelegate>(
            builder: (context, homeRouterDelegate, child) => Router(
                  routerDelegate: homeRouterDelegate,
                  backButtonDispatcher: childBackButtonDispatcher,
                )));
  }
}
