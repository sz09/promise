import 'package:collection/collection.dart';
import 'package:promise/const/const.dart';
import 'package:promise/repositories/database/local.database.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/repositories/base/base.repository.dart';
import 'package:promise/util/response.ext.dart';

abstract class BaseLocalRepository<T extends BaseAuditModel> extends BaseRepository {
  final String userId;
  final LocalDatabase<T> localDatabase;
  BaseLocalRepository({required this.userId, required this.localDatabase}) {}

  @override
  Future<T> createAsync(dynamic t) async {
    var box = await localDatabase.getBoxAsync();
    t.userId = this.userId;
    box.put(t.id, t);
    await box.flush();
    return t;
  }

  @override
  Future<T> modifyAsync(dynamic t) async {
    var box = await localDatabase.getBoxAsync();
    box.put(t.id, t);
    await box.flush();
    return t;
  }
  
  @override
  Future deleteAsync(String id) async {
    var box = await localDatabase.getBoxAsync();
    var model = box.values.firstWhereOrNull((d) => d.id == id);
    if(model != null){
      model.isDeleted = true;
      box.put(id, model);
      await box.flush();
    }
  }

  Future<Iterable<T>> createManyAsync(Iterable<T> ts) async {
    var box = await localDatabase.getBoxAsync();
    for (var element in ts) { element.userId = this.userId; }
    box.addAll(ts);
    await box.flush();
    return ts;
  }

  
  Future deleteManyAsync() async {
    var box = await localDatabase.getBoxAsync();
    box.clear();
    await box.flush();
  }

  Future<PageResult<T>> fetchDirtyPagingAsync([int page = 1, int pageSize = PAGE_SIZE]) async {
    var box = await localDatabase.getBoxAsync();
    query(T d) => d.userId == userId && d.dirty == true;
    var count = box.values.where(query).length;
    if(count == 0){
      return PageResult<T>.set([], 0);
    }
    var values = box.values
                    .where(query)
                    .sortedBy((d) => d.createdAt)
                    .skip((page - 1) * pageSize)
                    .take(pageSize)
                    .toList();
    return PageResult<T>.set(values, count);
  }

  Future markIsNotDirtyAsync(List<String> ids) async {
    var box = await localDatabase.getBoxAsync();
    for (var id in ids) {
      var model = box.get(id);
      if(model != null){
        model.dirty = false;
        box.put(id, model);
      }
    }
    await box.flush();
  }

  @override
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]) async {
    var box = await localDatabase.getBoxAsync();
    query(T d) => d.userId == userId && d.isDeleted == false;
    var count = box.values.where(query).length;
    if(count == 0){
      return PageResult<T>.set([], 0);
    }
    var values = box.values
                    .where(query)
                    .sortedBy((d) => d.createdAt);

    return PageResult<T>.set(values, count);
  }

  Future<PageResult<T>> fetchAsync1([int page = 1, int pageSize = PAGE_SIZE]) async {
    var box = await localDatabase.getBoxAsync();
    query(T d) => d.isDeleted == false;
    var count = box.values.where(query).length;
    if(count == 0){
      return PageResult<T>.set([], 0);
    }
    var values = box.values
                    .where(query)
                    .sortedBy((d) => d.createdAt);

    return PageResult<T>.set(values, count);
  }


  Future<T?> fetchOneAsync(bool Function(T) predicate) async {
    final box = await localDatabase.getBoxAsync();
    query(T d) => d.isDeleted == false;
    return box.values.firstWhereOrNull((d) => query(d) && predicate(d));
  }

  Future doSyncToLocalAsync(List<T> data) async {
    var box = await localDatabase.getBoxAsync();
    Map<String, T> map = { for (var item in data) item.id : item };
    await box.putAll(map);
    await box.close();
  }
  @override
  Future teardown() async {
    
  }
}