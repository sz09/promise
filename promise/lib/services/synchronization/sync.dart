import 'package:promise/di/service_locator.dart';
import 'package:promise/services/synchronization/synchronization.service.dart';

Future<Map<String, String?>> syncDataToLocalAsync(){
  return Future<Map<String, String?>>.microtask(() {
    var synchronizationService = serviceLocator.get<SynchronizationService>();
    return synchronizationService.doSyncToLocalAsync();
  });
}

Future syncDataToServerAsync(){
  return Future.microtask(() {
    var synchronizationService = serviceLocator.get<SynchronizationService>();
    return synchronizationService.doSyncToServerAsync();
  });
}