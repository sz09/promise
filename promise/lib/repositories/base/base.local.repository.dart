import 'package:collection/collection.dart';
import 'package:promise/..const/const.dart';
import 'package:promise/repositories/database/local.database.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/repositories/base/base.repository.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/string_util.dart';

abstract class BaseLocalRepository<T extends BaseAuditModel> extends BaseRepository {
  final String userId;
  late String tableName;
  final LocalDatabase<T> localDatabase;
  BaseLocalRepository({required this.userId, required this.localDatabase}) {
    tableName = (T).toPlural();
  }

  @override
  Future<T> createAsync(dynamic t) async {
    var box = await localDatabase.getBoxAsync();
    box.add(t);
    await box.flush();
    return t;
  }

  Future<Iterable<T>> createManyAsync(Iterable<T> ts) async {
    var box = await localDatabase.getBoxAsync();
    box.addAll(ts);
    await box.flush();
    return ts;
  }

  @override
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]) async {
    var box = await localDatabase.getBoxAsync();
    query(T d) => d.userId == userId;
    var count = box.values.where(query).length;
    if(count == 0){
      return PageResult<T>.set([], 0);
    }
    var values = box.values
                    .where(query)
                    .sortedBy((d) => d.createdAt);

    return PageResult<T>.set(values, count);
  }
  @override
  Future teardown() async {
    
  }
}