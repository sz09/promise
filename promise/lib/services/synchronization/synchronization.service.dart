import 'package:promise/models/base/base.model.dart';
import 'package:promise/models/sync/sync.dart';
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

  Future<Map<String, String?>> doSyncToLocalAsync() async {
    if(repositories.isEmpty){
      return {};
    }

    late Map<String, String?> syncResult = {};
    var systemVerionBox = await LocalDatabase<SystemVersion>().getBoxAsync();
    var userId = repositories.entries.first.value.userId;
    bool isNeedSync = true;
    do {
      SystemVersion? systemVersion = null;
      await _lock.synchronized(() async {
        if(!systemVerionBox.values.any((d) => d.userId == userId)){
          await systemVerionBox.put(userId, SystemVersion(id: userId, userId: userId, versions: {}));
          await systemVerionBox.flush();
        }

        systemVersion = systemVerionBox.values.singleWhere((d) => d.userId == userId);
      });

      var syncTasks = repositories.entries.map((map) => Future.microtask(() async {
        var tableName = map.value.localDatabase.boxName;
        var storedVersion = systemVersion!.versions[tableName] ?? BigInt.zero;
        try {
          final fetchData = await map.key.fetchFromVersionAsync(version: storedVersion);
          if(fetchData.data.isEmpty && fetchData.version == BigInt.zero){
            return SyncDataItemResult(
              tableName: tableName,
              isContinue: false
            );
          }
          await map.value.doSyncToLocalAsync(fetchData.data);
          fetchData.data.sort((d, e) => d.updatedAt!.isBefore(e.updatedAt!) ? 0: 1);
          await updateSystemVersion(systemVersion: systemVersion!, key: map.value.localDatabase.boxName, version: fetchData.version);

          var syncDataItemResult = SyncDataItemResult(
            tableName: tableName,
            isContinue: fetchData.version < fetchData.lastVersion
          );
          syncDataItemResult.isSynced = true;
          return syncDataItemResult;
        }
        catch(ex) {
          return SyncDataItemResult(tableName: tableName, isContinue: false) 
          ..isSynced = false
          ..reason = ex.toString();
        }
      })).toList();

      var result = await Future.wait(
        syncTasks
      );
      if(result.any((d) => d.isSynced)){
        await systemVerionBox.put(systemVersion!.id, systemVersion!);
        await systemVerionBox.flush();
      }

      isNeedSync = result.any((d) => d.isContinue);
      for(var item in result) {
        syncResult[item.tableName] = item.reason;
      }
    } while(isNeedSync);

    return syncResult;
  }

  Future<Map<String, BigInt>?> doSyncToServerAsync() async{
    if(repositories.isEmpty){
      return {};
    }

    late Map<String, BigInt?> syncResult = {};
    var systemVerionBox = await LocalDatabase<SystemVersion>().getBoxAsync();
    var userId = repositories.entries.first.value.userId;
    bool isNeedSync = true;
    do {
      SystemVersion? systemVersion = null;
      await _lock.synchronized(() async {
        if(!systemVerionBox.values.any((d) => d.userId == userId)){
          await systemVerionBox.put(userId, SystemVersion(id: userId, userId: userId, versions: {}));
          await systemVerionBox.flush();
        }

        systemVersion = systemVerionBox.values.singleWhere((d) => d.userId == userId);
      });
      
      var syncTasks = repositories.entries.map((map) => Future.microtask(() async {
        var tableName = map.value.localDatabase.boxName;
        try {
          final dirtyData = await map.value.fetchDirtyPagingAsync();
          if(dirtyData.data.isEmpty){
            return SyncDataItemResult(
              tableName: tableName,
              isContinue: false
            );
          }
          final localData = dirtyData.data.map((d) {
            if(d.isInsert){
              return SyncInsert<BaseAuditModel>(value: d);
            }

            if(d.isDeleted){
              return SyncDelete<BaseAuditModel>(id: d.id);
            }

            return SyncUpdate<BaseAuditModel>(id: d.id, value: d);
          }).toList();
          final lastVersion = await map.key.syncToServerAsync(localData);
          await map.value.markIsNotDirtyAsync(dirtyData.data.map((d) => d.id).toList());
          await updateSystemVersion(systemVersion: systemVersion!, key: map.value.localDatabase.boxName, version: lastVersion);
          var syncDataItemResult = SyncDataItemResult(
            tableName: tableName,
            isContinue: dirtyData.total > dirtyData.data.length
          );
          syncDataItemResult.isSynced = true;
          return syncDataItemResult;
        }
        catch(ex) {
          return SyncDataItemResult(tableName: tableName, isContinue: false) 
          ..isSynced = false
          ..reason = ex.toString();
        }
      })).toList();

      var result = await Future.wait(
        syncTasks
      );
      if(result.any((d) => d.isSynced)){
        await systemVerionBox.put(systemVersion!.id, systemVersion!);
        await systemVerionBox.flush();
      }

      isNeedSync = result.any((d) => d.isContinue);
      for(var item in result) {
        syncResult[item.tableName] = BigInt.zero;
      }
    }
    while(isNeedSync);
    return {};
  }
  
  Future updateSystemVersion({required SystemVersion systemVersion, required String key, required BigInt version}) async{
    await _lock2.synchronized(() async {
      systemVersion.versions[key] = version;
    });
  }
}