import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' hide ChangeNotifierProvider;
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/post_app_config.dart';
import 'package:promise/const/locale.const.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/resources/localization/localization_notifier.dart';
import 'package:promise/resources/theme/app_theme.dart';
import 'package:promise/resources/theme/theme_change_notifier.dart';
import 'package:promise/routers/router.config.dart';
import 'package:promise/routing/app_router_delegate.dart';
import 'package:promise/user/user_manager.dart';
import 'package:promise/util/app_lifecycle_observer.dart';
import 'package:promise/widgets/debug_overlay.dart';
import 'package:provider/provider.dart';
import 'app_localization.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final authNavigatorKey = GlobalKey<NavigatorState>();
final homeNavigatorKey = GlobalKey<NavigatorState>();

/// Provider that tracks the current locale of the app
final currentLocaleProvider = StateProvider<Locale>((_) => const Locale('en', 'US'));

class App extends StatefulWidget {
  const App({super.key});
  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
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
          theme: themeLight(),
          darkTheme: themeDark(),
          themeMode: themeObject.getThemeMode,
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: localeObject.locale,
          supportedLocales: SUPPORT_LOCALES,
          routes: APPLICATION_ROUTES,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale!.languageCode && locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            // coverage:ignore-start
            return supportedLocales.first;
            // coverage:ignore-end
          },
          // home: Stack(
          //   children: [
          //     Router(
          //       routerDelegate: _appRouterDelegate,
          //       backButtonDispatcher: RootBackButtonDispatcher(),
          //     ),
          //     const OverlayView(),
          //   ],
          // ),
        );
      }),
    );
  }

  @override
  void dispose() {
    serviceLocator.get<AppLifecycleObserver>().deactivate();
    super.dispose();
  }
}
