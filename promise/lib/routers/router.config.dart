
// ignore_for_file: non_constant_identifier_names, prefer_function_declarations_over_variables

import 'package:flutter/material.dart';
import 'package:promise/app_1.dart';
import 'package:promise/features/auth/login/ui/login_page.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/ui/promise_list_page.dart';
import 'package:promise/features/settings/ui/settings_page.dart';
import 'package:promise/util/localize.ext.dart';

const String _loginRoute = "/login";
const String _promisesRoute = "/promises";
const String _memoriesRoute = "/memories";
const String _settingsRoute = "/settings";

final APPLICATION_ROUTES = 
<String, WidgetBuilder> {
  // "/" : (BuildContext context) => const TimelinePage(),
  _loginRoute : (BuildContext context) => const LoginPage(),
  _promisesRoute: (BuildContext context) => PromiseListPage(),
  _memoriesRoute: (BuildContext context) => MemoryListPage(),
  _settingsRoute: (BuildContext context) => const SettingsPage(),
};
final x = ApplicationLayout();
final ROUTER_HANDLER = (settings) {
    Widget page;
    String titleKey = '';
    switch (settings.name) {
      case _loginRoute:
        return MaterialPageRoute(builder: (context) => const LoginPage());
      case '/':
        titleKey = "menu.home";
        page = const HomeScreen();
        break;
      case _promisesRoute:
        titleKey = "menu.promises";
        page = PromiseListPage();
        break;
      case _memoriesRoute:
        titleKey = "menu.memories";
        page = MemoryListPage();
        break;
      case '/settings':
        titleKey = "menu.settings";
        page = const SettingsPage();
        break;
      default:
        page = const NotFoundScreen();
    }
    x.navigateTo(settings.name, titleKey);

    return MaterialPageRoute(builder: (context) => x);
  };