import 'package:promise/models/person/person.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/di/service_locator.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/pre_app_config.dart';
import 'package:promise/repositories/memories/memory.local.repository.dart';
import 'package:promise/repositories/memories/memory.remote.repository.dart';
import 'package:promise/repositories/people/people.local.repository.dart';
import 'package:promise/repositories/people/people.remote.repository.dart';
import 'package:promise/repositories/promises/promise.remote.repository.dart';
import 'package:promise/repositories/promises/promise.local.repository.dart';
import 'package:promise/services/memory/memory.service.dart';
import 'package:promise/services/person/person.service.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/services/synchronization/sync.dart';
import 'package:promise/services/synchronization/synchronization.service.dart';
import 'package:promise/util/log/log.dart';

/// User scoped components that are created when the user logs in
/// and destroyed on logout.
const String userScopeName = 'userScope';

late Future<void> _syncFuture;

/// Use [setupUserScope] to setup components that need to be alive as
/// long as there is a logged in user. Provide a dispose method when
/// registering that will be invoked when this scope is torn down.
Future<void> setupUserScope(String userId) async {
  //todo add other user scope dependencies here, mind to provide dispose methods

  final MemoryLocalRepository memoryLocalRepository = MemoryLocalRepository(userId: userId, localDatabase: localDatabaseWrapper.getLocalDatabase<Memory>());
  final MemoryRemoteRepository memoryRemoteRepository = serviceLocator.get<MemoryRemoteRepository>();
  final MemoryService memoryService = MemoryService(remoteRepository: memoryRemoteRepository, localRepository: memoryLocalRepository);

  final PromiseLocalRepository promiseLocalRepository = PromiseLocalRepository(userId: userId, localDatabase: localDatabaseWrapper.getLocalDatabase<Promise>());
  final PromiseRemoteRepository promiseRemoteRepository = serviceLocator.get<PromiseRemoteRepository>();
  final PromiseService promiseService = PromiseService(remoteRepository: promiseRemoteRepository, localRepository: promiseLocalRepository);

  final PersonLocalRepository personLocalRepository = PersonLocalRepository(userId: userId, localDatabase: localDatabaseWrapper.getLocalDatabase<Person>());
  final PersonRemoteRepository personRemoteRepository = serviceLocator.get<PersonRemoteRepository>();
  final PersonService personService = PersonService(remoteRepository: personRemoteRepository, localRepository: personLocalRepository);

  final SynchronizationService synchronizationService = SynchronizationService(
    repositories: {
      // memoryRemoteRepository: memoryLocalRepository,
      // promiseRemoteRepository: promiseLocalRepository,
      // personRemoteRepository: personLocalRepository
    }
  );
  serviceLocator
    ..registerSingleton<MemoryService>(memoryService,
        dispose: (instance) => instance.teardown())
    ..registerSingleton<PromiseService>(promiseService,
        dispose: (instance) => instance.teardown())
    ..registerSingleton<PersonService>(personService,
        dispose: (instance) => instance.teardown())
    ..registerSingleton(synchronizationService);

  

 _syncFuture = syncDataToLocalAsync();
 _syncFuture.whenComplete(() {
  Log.d('Synced data to local');
 });
}

/// Use [teardownUserScope] to dispose the user scoped components if
/// you haven't provided a dispose method when registering.
Future<void> teardownUserScope() async {
  Log.w('Ignore synchronyzation data');
  _syncFuture.ignore();
  //todo teardown user scope components registered without dispose method here
}
