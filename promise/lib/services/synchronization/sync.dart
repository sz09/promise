import 'package:promise/di/service_locator.dart';
import 'package:promise/services/synchronization/synchronization.service.dart';

Future<void> syncDataToLocalAsync(){
  return Future.microtask(() {
    var synchronizationService = serviceLocator.get<SynchronizationService>();
    return synchronizationService.doSyncToLocalAsync();
  });
}