// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:promise/app_1.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/util/localize.ext.dart';

import '../../app_localization.dart';
import '../../pages.dart';
import '../../dynamic_menu.dart';
import '../../settings.dart';

const drawerMenuKey = Key("drawer_menu");
const closeMenuKey = Key("close_key_icon");

const todoTileKey = Key("todo_tile");
const tourTileKey = Key("tour_tile");
const settingsTileKey = Key("settings_tile");

const dynamicMenuItemListKey = Key('dynamic_menu_item_list');

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
          backgroundColor: Colors.black,
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
              icon: const Icon(
                Icons.menu_open,
                color: Colors.white,
              ),
            ),
          ]),
      body: Column(
        children: [
          Expanded(
            child: 
            Container(
              color: Colors.black,
              child: ListView(key: todoTileKey, padding: const EdgeInsets.only(top: 32), 
              children: [
                _getMenuItem(context: context, key: const Key('home_title'),  icon: Icons.login, route: '/', titleKey: 'menu.home'),
                _getMenuItem(context: context, key: const Key('login_title'),  icon: Icons.login, route: '/login', titleKey: 'menu.login'),
                _getMenuItem(context: context, key: const Key('promise_title'), icon: Icons.settings, route: '/promises', titleKey: 'menu.promises'),
                _getMenuItem(context: context, key: const Key('memory_title'), icon: Icons.settings, route: '/memories', titleKey: 'menu.memories'),
                _getMenuItem(context: context, key: const Key('setting_title'), icon: Icons.settings, route: '/settings', titleKey: 'menu.settings'),
            ])),
          ),
        ],
      ),
    );
  }
}

Container _getMenuItem({
  required BuildContext context, 
  required Key key,  
  required String route, 
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
          color: Colors.white,
          size: 40,
        ),
        title: Text(context.translate(titleKey),
            style: const TextStyle(
              fontSize: 25,
              color: Colors.white,
            )),
        onTap: () {
          var applicationLayout = applicationKey.currentWidget as ApplicationLayout;
          applicationLayout.navigateTo(route, context.translate(titleKey));
        },
      ),
    );
}