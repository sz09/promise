
// ignore_for_file: non_constant_identifier_names, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:promise/app_1.dart';
import 'package:promise/application_layout_widget.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/ui/promise_list_page.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';

const String loginRoute = "/login";
const String logoutRoute = "/logout";
const String promisesRoute = "/promises";
const String memoriesRoute = "/memories";
const String settingsRoute = "/settings";

final APPLICATION_ROUTES = 
<String, WidgetBuilder> {
  // "/" : (BuildContext context) => const TimelinePage(),
  loginRoute : (BuildContext context) => const LoginPage(),
  logoutRoute : (BuildContext context) => const LoginPage(),
  // promisesRoute: (BuildContext context) => const PromiseListPage(),
  // memoriesRoute: (BuildContext context) => const MemoryListPage(),
  // settingsRoute: (BuildContext context) => const SettingsPage(),
};
final ROUTER_HANDLER = (settings) {
    // Widget page;
    // String titleKey = '';
    switch (settings.name) { 
      case logoutRoute:
      case loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginPage());
     
      case '/':
        return MaterialPageRoute(builder: (context) => ApplicationLayout(widgetKey: 'timeline.title', child: const TimelinePage()));
      case promisesRoute:
        return MaterialPageRoute(builder: (context) => ApplicationLayout(widgetKey: 'promise.title', child: const PromiseListPage()));
      case memoriesRoute:
        return MaterialPageRoute(builder: (context) => ApplicationLayout(widgetKey: 'memory.title', child: const MemoryListPage()));
      // case '/settings':
      //   titleKey = "menu.settings";
      //   page = const SettingsPage();
      //   break;
      default:
        // page = const NotFoundScreen();
        return MaterialPageRoute(builder: (context) => ApplicationLayout222());
    }    
  };