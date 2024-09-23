import 'package:dio/dio.dart';
import 'package:promise/const/const.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';
import 'package:promise/util/response.ext.dart';

class MemoryRemoteRepository extends BaseRemoteRepository<Memory> {
  MemoryRemoteRepository({required super.client});

  @override
  String path = "/memories";

  @override
  Memory Function(Map<String, dynamic> p1) itemFactoryMethod = Memory.fromJson;

  Future<PageResult<Memory>> fetchCrashAsync(
      [int page = 1, int pageSize = PAGE_SIZE]) async {
    final pageResult = PageResult<Memory>.set([], 0);
    PageResult<Memory> factoryMethod(Response<dynamic> response) {
      if (response.data['data'] is List &&
          (response.data['data'] as List).isEmpty) {
        return PageResult.defaultValue();
      }

      pageResult.response = response.data;
      pageResult.resolveItem = itemFactoryMethod;
      pageResult.create();
      return pageResult;
    }

    var fetchData = await client.fetch<Memory>("$path/crash-endpoint",
        {'page': page, 'pageSize': pageSize}, factoryMethod);

    return fetchData.data!;
  }
}
