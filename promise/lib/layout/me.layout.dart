
import 'package:flutter/material.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/promise/ui/promise_list_page.dart';
import 'package:promise/util/localize.ext.dart';

class MeLayout extends StatefulWidget {
  static final GlobalKey<_MeLayoutState> _key = GlobalKey<_MeLayoutState>();
  MeLayout(): super(key: _key);
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
  State<StatefulWidget> createState() => _MeLayoutState();
}

class _MeLayoutState extends State<MeLayout> {
  final PageController _pageController = PageController();
  late int _selectedIndex = 0;

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
        children: [
          PromiseListPage(),
          MemoryListPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.record_voice_over_outlined),
            label: context.translate('promise_title'),
            backgroundColor: _getBackgroundColor(0)
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.cyclone_outlined),
            label: context.translate('memory_title'),
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