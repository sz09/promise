import 'package:hive/hive.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/repositories/database/local.database.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/repositories/memories/memory.local.repository.dart';
import 'package:promise/repositories/memories/memory.remote.repository.dart';
import 'package:promise/repositories/promises/promise.remote.repository.dart';
import 'package:promise/repositories/promises/promise.local.repository.dart';
import 'package:promise/services/memory/memory.service.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/services/synchronization/synchronization.service.dart';
import 'package:promise/util/string_util.dart';

/// User scoped components that are created when the user logs in
/// and destroyed on logout.
const String userScopeName = 'userScope';

/// Use [setupUserScope] to setup components that need to be alive as
/// long as there is a logged in user. Provide a dispose method when
/// registering that will be invoked when this scope is torn down.
Future<void> setupUserScope(String userId) async {
  //todo add other user scope dependencies here, mind to provide dispose methods
  final localDatabaseWrapper = LocalDatabaseWrapper();
  await localDatabaseWrapper.init({ 
    (Memory).toPlural(),
    (Promise).toPlural(),
  });

  Hive.registerAdapter(MemoryAdapter());
  Hive.registerAdapter(PromiseAdapter());
  final MemoryLocalRepository memoryLocalRepository = MemoryLocalRepository(userId: userId, localDatabase: localDatabaseWrapper.getLocalDatabase<Memory>());
  final MemoryRemoteRepository memoryRemoteRepository = serviceLocator.get<MemoryRemoteRepository>();
  final MemoryService memoryService = MemoryService(remoteRepository: memoryRemoteRepository, localRepository: memoryLocalRepository);

  final PromiseLocalRepository promiseLocalRepository = PromiseLocalRepository(userId: userId, localDatabase: localDatabaseWrapper.getLocalDatabase<Promise>());
  final PromiseRemoteRepository promiseRemoteRepository = serviceLocator.get<PromiseRemoteRepository>();
  final PromiseService promiseService = PromiseService(remoteRepository: promiseRemoteRepository, localRepository: promiseLocalRepository);

  final SynchronizationService synchronizationService = SynchronizationService(
    repositories: {
      memoryRemoteRepository: memoryLocalRepository,
      promiseRemoteRepository: promiseLocalRepository
    }
  );
  serviceLocator
    ..registerSingleton<MemoryService>(memoryService,
        dispose: (instance) => instance.teardown())
    ..registerSingleton<PromiseService>(promiseService,
        dispose: (instance) => instance.teardown())
    ..registerSingleton(synchronizationService);
}

/// Use [teardownUserScope] to dispose the user scoped components if
/// you haven't provided a dispose method when registering.
Future<void> teardownUserScope() async {
  //todo teardown user scope components registered without dispose method here
}
