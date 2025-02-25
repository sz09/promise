import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/route_manager.dart';
import 'package:promise/main.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

const drawerMenuKey = Key("drawer_menu");
const closeMenuKey = Key("close_key_icon");

const double _iconSize = 25;
const double _textSize = 20;
class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});
  
  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerMenuKey,
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/promise_logo.png",
                fit: BoxFit.fitHeight, height: 30),
          )),
      body: Column(children: _getMenuItems(context)),
    );
  }
}

List<Widget> _getMenuItems(BuildContext context) {
  var items = [
    _getMenuItem(
        context: context,
        key: const Key('home_title'),
        icon: FontAwesomeIcons.house,
        state: () async {
          await context.quickNavigateTo(homeRoute);
        },
        titleKey: 'menu.home'),
    _getMenuItem(
        context: context,
        key: const Key('promise_title'),
        icon: FontAwesomeIcons.handHoldingHeart,
        state: () async {
          await context.quickNavigateTo(promisesRoute);
        },
        titleKey: 'menu.promises'),
    _getMenuItem(
        context: context,
        key: const Key('memory_title'),
        icon: FontAwesomeIcons.cameraRetro,
        state: () async {
          await context.quickNavigateTo(memoriesRoute);
        },
        titleKey: 'menu.memories'),
    _getMenuItem(
        context: context,
        key: const Key('people_title'),
        icon: FontAwesomeIcons.userGroup,
        state: () async {
          await context.quickNavigateTo(peopleRoute);
        },
        titleKey: 'menu.people'),
    Expanded(child: Container()),
    _getMenuItem(
        context: context,
        key: const Key('setting_title'),
        icon: FontAwesomeIcons.gear,
        state: () async {
          await context.quickNavigateTo(settingsRoute);
        },
        titleKey: 'menu.settings'),
  ];

  if (userManager.isLoggedInUserSync()) {
    items.add(_getAuthMenuItem(
        context: context,
        key: const Key('logout_title'),
        icon: FontAwesomeIcons.rightFromBracket,
        route: logoutRoute,
        titleKey: 'menu.logout'));
  }
  return items;
}

Container _getMenuItem(
    {required BuildContext context,
    required Key key,
    required void Function()? state,
    required String titleKey,
    required IconData? icon}) {
  return Container(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white))),
    child: ListTile(
      key: key,
      leading: Icon(
        icon,
        color: context.iconColor,
        size: _iconSize,
      ),
      title: Text(context.translate(titleKey),
          style: TextStyle(
            fontSize: _textSize,
            color: context.textColor,
          )),
      onTap: () async {
        if (state != null) {
          state();
        }
      },
    ),
  );
}

Container _getAuthMenuItem(
    {required BuildContext context,
    required Key key,
    required String route,
    required String titleKey,
    required IconData? icon}) {
  return Container(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: context.borderColor))),
    child: ListTile(
      key: key,
      leading: Icon(
        icon,
        color: context.iconColor,
        size: _iconSize,
      ),
      title: Text(context.translate(titleKey),
          style: const TextStyle(fontSize: _textSize)),
      onTap: () async {
        await userManager.logout();
      },
    ),
  );
}

extension CustomNavigation on BuildContext {
  Future quickNavigateTo(String routeName) async {
    var navigator = Navigator.of(this);
    navigator.pop();
    await navigateTo(routeName);
  }

  Future navigateTo(String routeName) async {
    if (Get.routing.current != routeName) {
      await Get.toNamed(routeName);
    }
  }

  Future navigateToWithArguments(String routeName, Map<String, dynamic> arguments) async {
    if (Get.routing.current != routeName) {
      await Get.toNamed(routeName, arguments: arguments);
    }
  }
}
