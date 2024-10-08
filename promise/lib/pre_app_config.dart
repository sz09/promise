// ignore_for_file: unused_catch_clause

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive/hive.dart';
import 'package:promise/config/firebase_config.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/config/logger_config.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/features/settings/preferences_helper.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/models/system-versions/system-version.model.dart';
import 'package:promise/notifications/local/local_notification_manager.dart';
import 'package:promise/repositories/database/local.database.dart';
import 'package:promise/resources/localization/app_localization.dart';
import 'package:promise/user/user_manager.dart';
import 'package:promise/util/string_util.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const String themeModeKey = "isDarkMode";
const String languageCode = "languageCode";
GetStorage get getStorage  {
  return _getStorage ??= GetStorage();
}

GetStorage? _getStorage;

/// Configuration that needs to be done before the Flutter app starts goes here.
///
/// To minimize the app loading time keep this setup fast and simple.
Future<void> preAppConfig() async {
  await configureFirebase();
  initLogger();
  await setupGlobalDependencies();
  await Future.wait([
    serviceLocator.get<LocalNotificationsManager>().init(),
    serviceLocator.get<UserManager>().init(),
    serviceLocator.get<PreferencesHelper>().init()
  ]);
  
  var isDarkTheme = getStorage.read<bool>(themeModeKey) ?? false;
  Get.changeTheme(isDarkTheme ? ThemeData.dark() : ThemeData.light());
  var language = getStorage.read<String>(languageCode) ?? EN.languageCode;
  var locale =
      LocalizationService.locales.firstWhere((d) => d.languageCode == language);
  Get.updateLocale(locale);
}

final localDatabaseWrapper = LocalDatabaseWrapper();

registerDatabase() async {
  await localDatabaseWrapper.init({
    (SystemVersion).toPlural(),
    (Memory).toPlural(),
    (Promise).toPlural(),
    (Person).toPlural(),
  });
  Hive.registerAdapter(SystemVersionAdapter());
  Hive.registerAdapter(MemoryAdapter());
  Hive.registerAdapter(PromiseAdapter());
  Hive.registerAdapter(PersonAdapter());
}
late WebSocketChannel _channel;
Future<void> setupWebSocket(String userId) async {
  var baseUrlApi = FlavorConfig.values.baseUrlApi.replaceAll('https://', '').trim();
  final wsUrl = Uri.parse('ws://$baseUrlApi/ws/$userId');
  _channel = WebSocketChannel.connect(wsUrl);

  try {
    await _channel.ready;
  } on SocketException catch (e) {
    // Handle the exception.
  } on WebSocketChannelException catch (e) {
     // Handle the exception.
  }

  _channel.stream.listen((message) {
    _channel.sink.add('received $message!');
  });

}

Future closeWebSocketConnection() async {
 await  _channel.sink.close();
}
