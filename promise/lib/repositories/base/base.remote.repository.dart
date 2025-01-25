
import 'package:dio/dio.dart';
import 'package:promise/const/const.dart';
import 'package:promise/models/sync/sync.dart';
import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/repositories/base/base.repository.dart';
import 'package:promise/util/response.ext.dart';
import 'package:promise/util/sync_result.dart';

 abstract class BaseRemoteRepository<T extends BaseAuditModel> extends BaseRepository {
  abstract String path;
  abstract T Function(Map<String, dynamic>) itemFactoryMethod;
  
  DioClient client;
  BaseRemoteRepository({required this.client});

  @override
  Future<T> createAsync(BaseAuditModel t) async {
    var result = await this.client.post<T>(path, t, factoryMethod: itemFactoryMethod);
    return result.data!;
  }

  @override
  Future<T> modifyAsync(BaseAuditModel t) async {
    var result = await this.client.putModify<dynamic>(path, t, factoryMethod: itemFactoryMethod);
    return result.data!;
  }

  @override
  Future deleteAsync(String id) async {
    await this.client.delete<dynamic>("$path/$id");
  }

  @override
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]) async {
    final pageResult = PageResult<T>.set([], 0);
   PageResult<T> factoryMethod(Response<dynamic> response){
    if(response.data['data'] is List && (response.data['data'] as List).isEmpty){
      return PageResult.defaultValue();
    }

    pageResult.response = response.data;
    pageResult.resolveItem = itemFactoryMethod;
    pageResult.create();
    return pageResult;
  }
    var fetchData = await client.fetch<T>(path, {
      'page': page,
      'pageSize': pageSize
    },  factoryMethod);

    return fetchData.data!;
  }

  Future<SyncResult<T>> fetchFromVersionAsync({required BigInt version, int pageSize = FECTH_VERSION_PAGE_SIZE }) async {
    final syncResult = SyncResult<T>.set([], BigInt.zero);
    SyncResult<T> factoryMethod(Response<dynamic> response){
      if(response.data['data'] is List && (response.data['data'] as List).isEmpty){
        return SyncResult.defaultValue();
      }
      syncResult.response = response.data;
      syncResult.resolveItem = itemFactoryMethod;
      syncResult.create();
      return syncResult;
    }

    var fetchData = await client.fetchSync<T>('$path/from-version', {
      'fromVersion': version,
      'pageSize': pageSize
    },  factoryMethod);

    return fetchData.data!;
  }

  Future<BigInt> syncToServerAsync(List<SyncItem<T>> syncItems) async {
    var result = await client.post<BigInt>('$path/sync', syncItems, 
    factoryMethod: (response) => BigInt.parse(response['version'].toString()));
    return result.data!;
  }

  @override
  Future teardown() async {
    
  }
}
