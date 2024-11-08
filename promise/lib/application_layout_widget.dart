import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:promise/features/menu/menu.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/util/localize.ext.dart';

class ApplicationLayout extends StatelessWidget {
  final Widget child;
  final String widgetKey;
  final Function(BuildContext)? createFuntion;
  late int _selectedIndex = 1;
  ApplicationLayout(
      {super.key,
      required this.child,
      required this.widgetKey,
      this.createFuntion = null}) {
    switch (widgetKey) {
      case 'layout.chat_title':
        _selectedIndex = 1;
        break;
      case 'layout.me_title':
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
        await context.navigateTo(meRoute);
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
            actions: [
              if (createFuntion != null)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: IconButton(onPressed: () { 
                  createFuntion!(context);
                }, 
                icon: const Icon(FontAwesomeIcons.plus)),
              )
            ],
          ),
          drawer: const Drawer(width: 230, child: DrawerMenu()),
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
                  label: context.translate('layout.home'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.telegram),
                  label: context.translate('layout.chat'),
                ),
                BottomNavigationBarItem(
                  icon: const Icon(FontAwesomeIcons.person),
                  label: context.translate('layout.me'),
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (i) async => await _onItemTapped(i, context)),
        ));
  }
}
