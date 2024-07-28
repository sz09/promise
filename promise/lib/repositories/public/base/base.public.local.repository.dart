import 'package:collection/collection.dart';
import 'package:promise/..const/const.dart';
import 'package:promise/repositories/database/local.database.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/repositories/public/base/base.public.repository.dart';
import 'package:promise/util/invalid_operation_exception.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/string_util.dart';

abstract class BasePublicLocalRepository<T extends BaseModel> extends BasePublicRepository {
  late String tableName;
  late bool useLocalDatabase;
  final LocalDatabase<T>? localDatabase;
  BasePublicLocalRepository({this.useLocalDatabase = false, this.localDatabase}) {
    tableName = (T).toPlural();
    if(useLocalDatabase && localDatabase == null){
      throw InvalidOperationException('useLocalDatabase require localDatabase');
    }
  }

  @override
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]) async {
    if(!useLocalDatabase){
      return PageResult<T>.defaultValue();
    }

    var box = await localDatabase!.getBoxAsync();
    query(T d) => true;
    var count = box.values.where(query).length;
    if(count == 0){
      return PageResult<T>.set([], 0);
    }
    var values = box.values
                    .where(query)
                    .sortedBy((d) => d.id);

    return PageResult<T>.set(values, count);
  }
  @override
  Future teardown() async {
    
  }
}