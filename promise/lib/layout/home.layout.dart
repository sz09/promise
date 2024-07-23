
import 'package:flutter/material.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';
import 'package:promise/util/localize.ext.dart';

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
  void _onItemTapped(int index, { bool needJump = true }) {
    setState(() {
      _selectedIndex = index;
    });
    // Use PageController to jump to the selected page

    if(needJump) _pageController.jumpToPage(index);
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
        // Update the selected index when the page is changed by swiping
        onPageChanged:(index) => _onItemTapped(index, needJump: false),
        children: const [
          TimelinePage(),
          TimelinePage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.timeline),
            label: context.translate('timeline_title'),
            backgroundColor: _getBackgroundColor(0)
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.book_online_sharp),
            label: context.translate('stories_title'),
            backgroundColor: _getBackgroundColor(1)
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped
      ),
    );
  }
  
  _getBackgroundColor(int index) {
    return _selectedIndex == index ? const Color.fromARGB(0, 239, 172, 241) : const Color.fromARGB(0, 0, 0, 0);
  }
}