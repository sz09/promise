import 'package:promise/util/log/log.dart';
import 'package:promise/platform_comm/platform_comm.dart';
import 'package:promise/util/subscription.dart';

const String nativeLogs = 'nativeLogs';
const String platformTestMethod = 'platformTestMethod';
const String platformTestMethod2 = 'platformTestMethod2';

/// Platform methods specific for this app.
extension AppPlatformMethods on PlatformComm {
  /// Listens for custom log messages from the platform side.
  Subscription listenToNativeLogs() => listenMethod<String>(
      method: nativeLogs, callback: (logMessage) => Log.d(logMessage));

  /// For testing only.
  Future<String> echoMessage(String echoMessage) =>
      invokeMethod(method: platformTestMethod, param: echoMessage);
}
