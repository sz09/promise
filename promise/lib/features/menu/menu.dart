import 'dart:async';

import 'package:flutter/material.dart';
import 'package:promise/app.dart';
import 'package:promise/const/text.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/layout_util.dart';
import 'package:promise/util/localize.ext.dart';

import '../../settings.dart';

const drawerMenuKey = Key("drawer_menu");
const closeMenuKey = Key("close_key_icon");

const todoTileKey = Key("todo_tile");
const tourTileKey = Key("tour_tile");
const settingsTileKey = Key("settings_tile");

class DrawerMenu extends StatefulWidget {
  const DrawerMenu({super.key});

  @override
  State<DrawerMenu> createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  late Future<List<MenuItemInfo>> menuItems;

  @override
  void initState() {
    super.initState();
    menuItems = loadMenuItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerMenuKey,
      appBar: AppBar(
          backgroundColor: context.containerLayoutColor,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset("assets/images/promise_logo.png", fit: BoxFit.fitHeight, height: 30),
          ),
          actions: [
            IconButton(
              key: closeMenuKey,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.menu_open,
                color: context.iconColor,
              ),
            ),
          ]),
      body: Container(
        color: context.containerLayoutColor, 
        child: Column(
          children: _getMenuItems(context)
      )),
    );
  }
}

List<Widget> _getMenuItems(BuildContext context) {
  var items = [
    _getMenuItem(context: context, 
          key: const Key('home_title'), 
          icon: Icons.home, 
          state: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/');        
          }, 
          titleKey: 'menu.home'),
    _getMenuItem(context: context, 
          key: const Key('promise_title'), 
          icon: Icons.settings, 
          state: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(promisesRoute);
          },
          titleKey: 'menu.promises'),
    _getMenuItem(context: context, 
          key: const Key('memory_title'), 
          icon: Icons.settings, 
          state: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(memoriesRoute);
          }, 
          titleKey: 'menu.friends'),

    _getMenuItem(context: context, 
          key: const Key('friend_title'), 
          icon: Icons.settings, 
          state: (){
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(friendsRoute);
          }, 
          titleKey: 'menu.memories'),
    Expanded(child: Container()),
    _getMenuItem(context: context, 
          key: const Key('setting_title'), 
          icon: Icons.settings, 
          state: () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed(settingsRoute);
          },
          titleKey: 'menu.settings'),
  ];

  if(userManager.isLoggedInUserSync()){
    items.add(_getAuthMenuItem(context: context, 
    key: const Key('logout_title'),  
    icon: Icons.logout, 
    route: logoutRoute, titleKey: 'menu.logout'));
  }
  return items;
}

Container _getMenuItem({
  required BuildContext context, 
  required Key key,
  required void Function()? state,
  required String titleKey,
  required IconData? icon

}) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.white))),
      child: ListTile(
        key: key,
        leading: Icon(
          icon,
          color: context.iconColor,
          size: 40,
        ),
        title: Text(context.translate(titleKey),
            style: TextStyle(
              fontSize: 22,
              color: context.textColor,
            )),
        onTap: () async {
          if(state != null) {
            state();
          }
        },
      ),
    );
}

Container _getAuthMenuItem({
  required BuildContext context, 
  required Key key,  
  required String route, 
  required String titleKey,
  required IconData? icon

}) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: context.borderColor))),
      child: ListTile(
        key: key,
        leading: Icon(
          icon,
          color: context.iconColor,
          size: 40,
        ),
        title: Text(context.translate(titleKey),
            style: TextStyle(
              fontSize: 22,
              color: context.textColor,
            )),
        onTap: () async {
          switch(route){
            case logoutRoute: 
              await userManager.logout();
            case loginRoute: 
              homeNavigatorKey.currentState?.pushNamed(route);
          }
        },
      ),
    );
}