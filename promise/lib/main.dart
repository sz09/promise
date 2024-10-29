import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:promise/application_layout_widget.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/network.const.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/auth/login/login.controller.dart';
import 'package:promise/features/chat/chat_page.dart';
import 'package:promise/features/chat/ui/chat_one_page.dart';
import 'package:promise/features/create.controller.dart';
import 'package:promise/features/memory/ui/memory_list_page.dart';
import 'package:promise/features/page.controller.dart';
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
import 'package:promise/routing/navigation_observer.dart';
import 'package:promise/user/user_manager.dart';
import 'package:azure_app_config/azure_app_config.dart';
import 'main.reflectable.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

final userManager = serviceLocator.get<UserManager>();
const String applicationTag = "-application";
final navigationHistoryObserver = NavigationRoutesObserver();

void main() async {
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (kReleaseMode) {}
  };
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await GetStorage.init();
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

  await Future.wait(LocalizationService.langCodes
      .map((code) => LocalizationService.loadLanguage(languageCode: code)));
  await preAppConfig();
  final AppRouterDelegate appRouterDelegate = AppRouterDelegate(
    userManager,
  );
  var app = GetMaterialApp(
    home: Stack(children: [
      Router(
        routerDelegate: appRouterDelegate,
        backButtonDispatcher: RootBackButtonDispatcher(),
      ),
      const OverlayView(),
    ]),
    navigatorObservers: [navigationHistoryObserver],
    initialBinding: _InitialBinding(),
    locale: LocalizationService.locale,
    fallbackLocale: LocalizationService.fallbackLocale,
    themeMode: ThemeMode.light,
    theme: themeLight(),
    darkTheme: themeDark(),
    translations: LocalizationService(),
    initialRoute: homeRoute,
    defaultTransition: Transition.noTransition,
    transitionDuration: const Duration(seconds: 1),
    getPages: [
      GetPage(
          name: homeRoute,
          page: () => ApplicationLayout(
              widgetKey: 'timeline.title', child: const TimelinePage())),
      GetPage(
          name: promisesRoute,
          page: () => ApplicationLayout(
              widgetKey: 'promise.title', child: const PromiseListPage())),
      GetPage(
          name: memoriesRoute,
          page: () => ApplicationLayout(
              widgetKey: 'memory.title', child: const MemoryListPage())),
      GetPage(
          name: peopleRoute,
          page: () => ApplicationLayout(
              widgetKey: 'people.title', child: const PeoplePage())),
      GetPage(
          name: chatRoute,
          page: () => ApplicationLayout(
              widgetKey: 'chat.title', child: ChatPage())),
      GetPage(
          name: chatOneRoute,
          page: () => ApplicationLayout(
              widgetKey: 'chat.title', child: ChatOnePage())),
      GetPage(name: settingsRoute, page: () => const SettingsWidget()),
    ],
  );
  runApp(app);
  FlutterNativeSplash.remove();
}

class _InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController(), tag: applicationTag, fenix: true);
    Get.lazyPut(() => MemoryController(), tag: applicationTag, fenix: true);
    Get.lazyPut(() => PromiseController(), tag: applicationTag, fenix: true);
    Get.lazyPut(() => PeopleController(), tag: applicationTag, fenix: true);
    Get.lazyPut(() => TimelineController(), tag: applicationTag, fenix: true);
    Get.lazyPut(() => ChatOneController(), tag: applicationTag, fenix: true);
    Get.lazyPut(() => CreatePromiseController(), tag: applicationTag, fenix: true);
  }
}
