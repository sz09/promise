
import 'package:flutter/material.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';

class HomeLayout extends StatefulWidget {
  static final GlobalKey<_HomeLayoutState> _key = GlobalKey<_HomeLayoutState>();
  HomeLayout(): super(key: _key);
  
  jumpToPage(String pageRoute){
    final index = _findIndexByRoute(pageRoute);
    if(index > -1){
      _key.currentState!._onItemTapped(index);
      return true;
    }

    return false;
  }
  
  int _findIndexByRoute(String pageRoute){
    return 0;
  }
  @override
  State<StatefulWidget> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late int _selectedIndex = 0;
  final PageController _pageController = PageController();


    // Method to handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Use PageController to jump to the selected page
    _pageController.jumpToPage(index);
    switch(index) {
      case 0:
        // _promiseListPage.loadData();
        break;
      case 1:
        // _memoryListPage.loadData();
        break;

      default: 
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          TimelinePage()
        ],
        // Update the selected index when the page is changed by swiping
        onPageChanged: _onItemTapped,
      )
    );
  }
}