import 'package:promise/..config/flavor_config.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/platform_comm/platform_comm.dart';

/// Configuration that needs to be done after the Flutter app starts goes here.
///
/// To minimize the app loading time keep this setup fast and simple.
void postAppConfig() {
  _testPlatformCommunication();
}

void _testPlatformCommunication() {
  if (!FlavorConfig.isProduction()) {
    serviceLocator.get<String>(instanceName: buildVersionKey);
    serviceLocator
        .get<PlatformComm>()
        .echoMessage('echo')
        .catchError((error) => 'Test platform method error: $error')
        .then((backEcho) => Log.d("Test message 'echo' - '$backEcho'"));
    // serviceLocator
    //     .get<PlatformComm>()
    //     .echoObject(TaskGroup('TG-id', 'Test group', List.of(['1', '2'])))
    //     .then((backEcho) => Log.d("Test message TaskGroup - '$backEcho'"))
    //     .catchError((error) => Log.e('Test platform method err.: $error'));
  }
}
