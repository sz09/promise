
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:promise/application_layout_widget.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/network.const.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/people/ui/people_page.dart';
import 'package:promise/features/promise/ui/list/promise_list_page.dart';
import 'package:promise/features/settings/ui/settings_page.dart';
import 'package:promise/features/timeline/ui/timeline_page.dart';
import 'package:promise/overlay_view.dart';
import 'package:promise/pre_app_config.dart';
import 'package:promise/resources/localization/app_localization.dart';
import 'package:promise/resources/theme/app_theme.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_router_delegate.dart';
import 'package:promise/user/user_manager.dart';
import 'package:azure_app_config/azure_app_config.dart';
import 'main.reflectable.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();
final userManager = serviceLocator.get<UserManager>();

const String applicationTag = "application";

void main() async {
   FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {
      
    }
  };
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await registerDatabase();
  final service =
      AzureAppConfig(connectionString: azureAppConfigConnectionStringDev);
  var configs =
      (await service.findKeyValuesBy(key: "Mobile/*", label: Flavor.Dev.name));
  var result = {
    for (var v in configs) v.key.replaceFirst('Mobile/', ''): v.value
  };
  FlavorConfig.set(
    Flavor.Dev,
    FlavorValues(baseUrlApi: result['BaseUrlApi']!),
  );
  initializeReflectable();
  await Future.wait([
    LocalizationService.loadLanguage(languageCode: "en"),
    LocalizationService.loadLanguage(languageCode: "vi")
  ]);
  await preAppConfig();
  
  final AppRouterDelegate appRouterDelegate = AppRouterDelegate(
    rootNavigatorKey,
    authNavigatorKey,
    homeNavigatorKey,
    userManager,
  );

  runApp(GetMaterialApp(
    home: Stack(children: [
      Router(
        routerDelegate: appRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      const OverlayView(),
    ]),
    locale: LocalizationService.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    themeMode: ThemeMode.light,
    theme: themeLight(),
    darkTheme: themeDark(),
    translations: LocalizationService(),
    initialRoute: homeRoute,
    // routes: {
    //   homeRoute: (b) =>  ApplicationLayout(
    //         widgetKey: 'timeline.title', 
    //         child: const TimelinePage()),
    //   promisesRoute: (b) =>  ApplicationLayout(
    //         widgetKey: 'promise.title', 
    //         child: const PromiseListPage()),
    //   memoriesRoute: (b) => ApplicationLayout(
    //         widgetKey: 'memory.title', 
    //         child: const MemoryListPage()),
    //   peopleRoute: (b) => ApplicationLayout(
    //         widgetKey: 'people.title', 
    //         child: const PeoplePage())
    // },
    getPages: [
      GetPage(
          name: homeRoute,
          page: () => ApplicationLayout(
            widgetKey: 'timeline.title', 
            child: const TimelinePage())
          ),
      GetPage(
          name: promisesRoute,
          page: () => ApplicationLayout(
            widgetKey: 'promise.title', 
            child: const PromiseListPage())
          ),
      GetPage(
          name: memoriesRoute,
          page: () => ApplicationLayout(
            widgetKey: 'memory.title', 
            child: const MemoryListPage())
          ),
      GetPage(
          name: peopleRoute,
          page: () => ApplicationLayout(
            widgetKey: 'people.title', 
            child: const PeoplePage())
          ),
      GetPage(name: settingsRoute, page: () => const SettingsWidget())
    ],
  ));
  FlutterNativeSplash.remove();
}
