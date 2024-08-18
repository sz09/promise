import 'package:promise/config/firebase_config.dart';
import 'package:promise/config/logger_config.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/user/user_manager.dart';

/// Configuration that needs to be done before the Flutter app starts goes here.
///
/// To minimize the app loading time keep this setup fast and simple.
Future<void> preAppConfig() async {
  await configureFirebase();
  initLogger();
  await setupGlobalDependencies();
  // await serviceLocator.get<LocalNotificationsManager>().init(); //todo uncomment for local notifications
  await serviceLocator.get<UserManager>().init();
  await serviceLocator.get<PreferencesHelper>().init();
}
