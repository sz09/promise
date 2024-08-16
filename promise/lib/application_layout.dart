import 'package:flutter/material.dart';
import 'package:promise/features/menu/menu.dart';
import 'package:promise/features/page.deletegate.dart';
import 'package:promise/util/localize.ext.dart';

class ApplicationKey extends LocalKey {
}

var menu = const Drawer(
  child: DrawerMenu()
);

class ApplicationLayout extends Page {
  late Widget child;
  final String widgetKey;
  ApplicationLayout({required this.widgetKey,required this.child}): super(key: ApplicationKey());
  final PageController _pageController = PageController();
  late int _selectedIndex = 0;

    // Method to handle BottomNavigationBar imentem taps
  void _onItemTapped(int index) {
    _selectedIndex = index;
    // Use PageController to jump to the selected page
    _pageController.jumpToPage(index);
  }
  @override
  Route createRoute(BuildContext context) {
    return onCreateRoute(
      settings: this,
      builder: (BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(context.translate(widgetKey)),
      ),
      drawer: menu,
      body: PageView(
        controller: _pageController,
        children: [
          child
        ],
        // Update the selected index when the page is changed by swiping
        onPageChanged: (index) {
          _selectedIndex = index;
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'My',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped
      ),
    ),
    );
  } 
}