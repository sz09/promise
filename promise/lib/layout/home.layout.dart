
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  var rmicons = false;
  var mini = false;
  var extend = false;
  var buttonSize = const Size(56.0, 56.0);
  var childrenButtonSize = const Size(56.0, 56.0);
  var customDialRoot = false;
  var closeManually = false;
  var useRAnimation = true;  
  var renderOverlay = true;
  var visible = true;
  var switchLabelPosition = false;
  var speedDialDirection = SpeedDialDirection.up;
  var isDialOpen = ValueNotifier<bool>(false);
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
      floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          animatedIconTheme: const IconThemeData(size: 22.0),
          activeChild: const Text("close"),
          icon: Icons.navigate_next,
          activeIcon: Icons.close,
          spacing: 3,
          mini: mini,
          openCloseDial: isDialOpen,
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          dialRoot: customDialRoot
              ? (ctx, open, toggleChildren) {
                  return ElevatedButton(
                    onPressed: toggleChildren,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 18),
                    ),
                    child: const Text(
                      "Custom Dial Root",
                      style: TextStyle(fontSize: 17),
                    ),
                  );
                }
              : null,
          buttonSize:
              buttonSize, // it's the SpeedDial size which defaults to 56 itself
          // iconTheme: IconThemeData(size: 22),
          label: extend
              ? const Text("Open")
              : null, // The label of the main button.
          /// The active label of the main button, Defaults to label if not specified.
          activeLabel: extend ? const Text("Close") : null,

          /// Transition Builder between label and activeLabel, defaults to FadeTransition.
          // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
          /// The below button size defaults to 56 itself, its the SpeedDial childrens size
          childrenButtonSize: childrenButtonSize,
          visible: visible,
          direction: speedDialDirection,
          switchLabelPosition: switchLabelPosition,

          /// If true user is forced to close dial manually
          closeManually: closeManually,

          /// If false, backgroundOverlay will not be rendered.
          renderOverlay: renderOverlay,
          // overlayColor: Colors.black,
          // overlayOpacity: 0.5,
          onOpen: () => debugPrint('OPENING DIAL'),
          onClose: () => debugPrint('DIAL CLOSED'),
          useRotationAnimation: useRAnimation,
          tooltip: 'Open Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          // foregroundColor: Colors.black,
          // backgroundColor: Colors.white,
          // activeForegroundColor: Colors.red,
          // activeBackgroundColor: Colors.blue,
          elevation: 8.0,
          animationCurve: Curves.elasticInOut,
          isOpenOnStart: false,
          shape: customDialRoot
              ? const RoundedRectangleBorder()
              : const StadiumBorder(),
          // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          children: _getMenuItems(),
          // This is ignored if animatedIcon is non null
          child: const Text("open"),
        )
    );
  }
  
  List<SpeedDialChild> _getMenuItems(){
    var items = [
      SpeedDialChild(
        child: !rmicons ? const Icon(Icons.accessibility) : null,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: context.translate('menu.promises'),
        onTap: () => {
          _onItemTapped(0)
        },
        onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
      ),
      SpeedDialChild(
        child: !rmicons ? const Icon(Icons.accessibility) : null,
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        label: context.translate('menu.memories'),
        onTap: () => {
          _onItemTapped(1)
        },
        onLongPress: () => debugPrint('FIRST CHILD LONG PRESS'),
      ),
    ];
    items.removeAt(_selectedIndex);
    return items;
  }
  _getBackgroundColor(int index) {
    return _selectedIndex == index ? const Color.fromARGB(0, 239, 172, 241) : const Color.fromARGB(0, 0, 0, 0);
  }
}