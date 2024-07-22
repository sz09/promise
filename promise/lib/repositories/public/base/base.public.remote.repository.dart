import 'package:dio/dio.dart';
import 'package:promise/..const/const.dart';
import 'package:promise/networks/dio/dio.client.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/repositories/public/base/base.public.repository.dart';
import 'package:promise/util/response.ext.dart';

 abstract class BasePublicRemoteRepository<T extends BaseModel> extends BasePublicRepository {
  abstract String path;
  abstract T Function(Map<String, dynamic>) itemFactoryMethod;
  
  DioClient client;
  BasePublicRemoteRepository({required this.client});

  @override
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]) async {
    final pageResult = PageResult<T>.set([], 0);
   PageResult<T> factoryMethod(Response<dynamic> response){
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
  @override
  Future teardown() async {
    
  }
}
