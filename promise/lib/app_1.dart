import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:promise/..config/flavor_config.dart';
import 'package:promise/..config/post_app_config.dart';
import 'package:promise/..const/locale.const.dart';
import 'package:promise/app_localization.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/menu/menu.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/layout/home.layout.dart';
import 'package:promise/layout/me.layout.dart';
import 'package:promise/resources/localization/localization_notifier.dart';
import 'package:promise/resources/theme/theme_change_notifier.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_router_delegate.dart';
import 'package:promise/user/user_manager.dart';
import 'package:promise/util/app_lifecycle_observer.dart';
import 'package:promise/util/loader.dart';
import 'package:promise/widgets/debug_overlay.dart';
import 'package:provider/provider.dart';


final rootNavigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();
final applicationKey = GlobalKey<_ApplicationLayoutState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<MyApp> {
  late final AppRouterDelegate _appRouterDelegate;
  late final LocalizationNotifier _localizationNotifier;
  @override
  void initState() {
    super.initState();
    serviceLocator.get<AppLifecycleObserver>().activate();
    _appRouterDelegate = AppRouterDelegate(
      rootNavigatorKey,
      authNavigatorKey,
      homeNavigatorKey,
      serviceLocator.get<UserManager>(),
    );
    _localizationNotifier = LocalizationNotifier(
        serviceLocator.get<PreferencesHelper>().languagePreferred);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postAppConfig();
    if (!FlavorConfig.isProduction()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugOverlay(context);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    final applicationLayout = ApplicationLayout();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeChangeNotifier>(
          create: (context) =>
              serviceLocator.get<PreferencesHelper>().themePreferred,
        ),
        ChangeNotifierProvider<LocalizationNotifier>(
          create: (context) => _localizationNotifier,
        ),
        ChangeNotifierProvider<AppRouterDelegate>(
          create: (context) => _appRouterDelegate,
        ),
      ],
      child: Consumer2<LocalizationNotifier, ThemeChangeNotifier>(
          builder: (context, localeObject, themeObject, _) {
            return MaterialApp(
              title: 'Flutter Router Example',
              localizationsDelegates: const [
                AppLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: (deviceLocale, supportedLocales) {
                for (var locale in supportedLocales) {
                  if (locale.languageCode == deviceLocale!.languageCode && locale.countryCode == deviceLocale.countryCode) {
                    return deviceLocale;
                  }
                }
                // coverage:ignore-start
                return supportedLocales.first;
              },
              supportedLocales: SUPPORT_LOCALES,
              routes: APPLICATION_ROUTES,
              locale: localeObject.locale,
              home: Stack(
                children: [
                  applicationLayout,
                  // Router(
                  //   routerDelegate: _appRouterDelegate,
                  //   backButtonDispatcher: RootBackButtonDispatcher(),
                  // ),
                  const OverlayView(),
                ],
              ),
            );
          }
      )
    );
  }

  @override
  void dispose() {
    serviceLocator.get<AppLifecycleObserver>().deactivate();
    super.dispose();
  }
}

class OverlayView extends StatelessWidget {
  const OverlayView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      // <--- IMP , using ValueListenableBuilder for showing/removing overlay
      valueListenable: Loader.appLoader.loaderShowingNotifier,
      builder: (context, value, child) {
        return Container();
      },
    );
  }
}

class ApplicationLayout extends StatefulWidget {
  navigateTo(String? pageRoute, String title){
    if(pageRoute == null){
      return;
    }
    applicationKey.currentState!.title = title;
    applicationKey.currentState!._homeLayout.jumpToPage(pageRoute) 
    || 
    applicationKey.currentState!._meLayout.jumpToPage(pageRoute);
  }
  ApplicationLayout(): super(key: applicationKey);
  
  @override
  State<StatefulWidget> createState() => _ApplicationLayoutState();

  
}

class _ApplicationLayoutState extends State<ApplicationLayout> {
  late String title = 'haha';
  late int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final _meLayout = MeLayout();
  final _homeLayout = HomeLayout();

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
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const Drawer(
        child: DrawerMenu()
      ),
      body: PageView(
        controller: _pageController,
        children: [
          _homeLayout,
          _meLayout
        ],
        // Update the selected index when the page is changed by swiping
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
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
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Home Screen')
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('About Screen'),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('404 - Page Not Found'),
    );
  }
}
