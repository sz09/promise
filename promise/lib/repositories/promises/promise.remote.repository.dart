import 'package:promise/models/promise/promise.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';

class PromiseRemoteRepository extends BaseRemoteRepository<Promise> {
  PromiseRemoteRepository({required super.client});
  
  @override
  String path = "/promises";
  
  @override
  Promise Function(Map<String, dynamic> p1) itemFactoryMethod = Promise.fromJson;

}