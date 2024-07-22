import 'package:promise/models/memory/memory.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';

class MemoryRemoteRepository extends BaseRemoteRepository<Memory> {
  MemoryRemoteRepository({required super.client});
  
  @override
  String path = "/memories";
  
  @override
  Memory Function(Map<String, dynamic> p1) itemFactoryMethod = Memory.fromJson;

}