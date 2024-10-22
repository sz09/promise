import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/features/menu/menu.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/localize.ext.dart';

var menu = const Drawer(child: DrawerMenu());

class ApplicationLayout extends StatelessWidget {
  final Widget child;
  final String widgetKey;
  late int _selectedIndex = 1;
  ApplicationLayout({super.key, required this.child, required this.widgetKey}) {
    switch(widgetKey) {
       case 'chat.title': 
        _selectedIndex = 1;
        break;
       case 'me.title': 
        _selectedIndex = 2;
        break;
      default:
        _selectedIndex = 0;
        break;
    }
  }
  final PageController _pageController = PageController();

  // Method to handle BottomNavigationBar imentem taps
  Future _onItemTapped(int index, BuildContext context) async {
    switch (index) {
      case 0:
        await context.navigateTo(homeRoute);
        break;
      case 1:
        await context.navigateTo(chatRoute);
        break;
      case 2:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: ModalRoute.of(context)!.canPop,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          if (didPop) {
            return;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(context.translate(widgetKey)),
          ),
          drawer: menu,
          body: PageView(
            controller: _pageController,
            children: [child],
            // Update the selected index when the page is changed by swiping
            onPageChanged: (index) {
              _selectedIndex = index;
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              showSelectedLabels: false,
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: const Icon(Icons.home),
                  label: context.translate('Home'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.telegram),
                  label: context.translate('Chat'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.person),
                  label: context.translate('Me'),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (i) async => await _onItemTapped(i, context)),
        ));
  }
}
