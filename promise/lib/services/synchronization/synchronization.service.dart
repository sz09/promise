import 'package:promise/models/system-versions/system-version.model.dart';
import 'package:promise/repositories/base/base.local.repository.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';
import 'package:promise/repositories/database/local.database.dart';
import 'package:promise/util/sync_result.dart';
import 'package:synchronized/synchronized.dart';

class SynchronizationService {
  final Map<BaseRemoteRepository, BaseLocalRepository> repositories;
  final Lock _lock = Lock();
  final Lock _lock2 = Lock();
  SynchronizationService({required this.repositories});

  Future doSyncToLocalAsync() async {
    if(repositories.isEmpty){
      return;
    }

    var box = await LocalDatabase<SystemVersion>().getBoxAsync();
    var userId = repositories.entries.first.value.userId;
    bool isNeedSync = true;
    do {
      SystemVersion? systemVersion = null;
      await _lock.synchronized(() async {
        if(!box.values.any((d) => d.userId == userId)){
          await box.put(userId, SystemVersion(id: userId, userId: userId, versions: {}));
          await box.flush();
        }

        systemVersion = box.values.singleWhere((d) => d.userId == userId);
      });

      var syncTasks = repositories.entries.map((map) => Future.microtask(() async {
        var tableName = map.value.tableName;
        var storedVersion = systemVersion!.versions[tableName] ?? 0;
        final fetchData = await map.key.fetchFromVersionAsync(version: storedVersion);
        if(fetchData.data.isEmpty && fetchData.version == 0){
          return SyncDataItemResult(
            tableName: tableName,
            isContinue: false
          );
        }

        await map.value.doSyncToLocalAsync(fetchData.data);
        fetchData.data.sort((d, e) => d.updatedAt!.isBefore(e.updatedAt!) ? 0: 1);
        await updateSystemVersion(systemVersion: systemVersion!, key: map.value.tableName, version: fetchData.version);
        var syncDataItemResult = SyncDataItemResult(
          tableName: tableName,
          isContinue: fetchData.version < fetchData.lastVersion
        );
        syncDataItemResult.isSynced = true;
        return syncDataItemResult;
      }));

      var result = await Future.wait(
        syncTasks
      );
      if(result.any((d) => d.isSynced)){
        await box.put(systemVersion!.id, systemVersion!);
        await box.flush();
      }

      isNeedSync = result.any((d) => d.isContinue);
    } while(isNeedSync);
  }


  Future doSyncToServerAsync() async{

  }
  
  Future updateSystemVersion({required SystemVersion systemVersion, required String key, required int version}) async{
    await _lock2.synchronized(() async {
      systemVersion.versions[key] = version;
    });
  }
}