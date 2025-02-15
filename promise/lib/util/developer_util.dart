import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:promise/config/flavor_config.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/util/log/file_logger.dart';
import 'package:promise/user/user_manager.dart';
import 'package:path_provider/path_provider.dart';

/// Opens an email window with the [FileLogger]'s logs attached.
Future<void> sendDeveloperInfo() async {
  FileLogger fileLogger = serviceLocator.get<FileLogger>();
  UserManager userManager = serviceLocator.get<UserManager>();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  String device = 'unknown device';
  String osVersion = 'unknown OS version';
  if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    device = iosInfo.model;
    osVersion = iosInfo.systemVersion;
  } else if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    device = androidInfo.model;
    osVersion = androidInfo.version.sdkInt.toString();
  }

  return _sendDeveloperInfo(
    logFilePath: await fileLogger.getLogFilePath(),
    appName: packageInfo.appName,
    appVersion: packageInfo.version,
    userId: (await userManager.getLoggedInUser())?.user.userId ?? 'n/a',
    username: (await userManager.getLoggedInUser())?.user.username ?? 'n/a',
    flavor: FlavorConfig.flavorName,
    platform: Platform.isIOS
        ? 'iOS'
        : Platform.isAndroid
            ? 'Android'
            : 'Web',
    osVersion: osVersion,
    device: device,
    //recipients: [todo add recipients and optionally cc recipients],
  );
}

Future<void> _sendDeveloperInfo({
  required String logFilePath,
  String appName = '',
  String appVersion = '',
  String userId = 'n/a',
  String username = 'n/a',
  String flavor = 'unknown flavor',
  String platform = 'unknown platform',
  String osVersion = 'unknown OS version',
  String device = 'unknown device',
  Iterable<String> recipients = const [],
  Iterable<String> cc = const [],
}) async {
  if (Platform.isAndroid) {
    // Copy the file to temp directory, otherwise can't be attached to the email
    // https://github.com/sidlatau/flutter_email_sender/issues/35
    String tempDirectoryPath = (await getTemporaryDirectory()).path;
    String fileName = logFilePath.split('/').last;

    File copy = await File(logFilePath).copy('$tempDirectoryPath/$fileName');
    logFilePath = copy.path;
  }

  final userInfo = 'User id: $userId\n User email: $username';
  final deviceInfo = 'Device: $device OS: $osVersion';
  final appInfo = 'App version: $appVersion';

  Email email = Email(
    body: '$userInfo\n$deviceInfo\n$appInfo',
    subject: '[$flavor][$platform] $appName Developer Report',
    recipients: recipients.toList(),
    cc: cc.toList(),
    attachmentPaths: [logFilePath],
    isHTML: false,
  );

  await FlutterEmailSender.send(email);
}
