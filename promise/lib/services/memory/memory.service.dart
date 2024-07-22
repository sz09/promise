import 'package:promise/models/memory/memory.dart';
import 'package:promise/services/base/base.service.dart';

class MemoryService extends BaseService<Memory> {
  MemoryService({required super.remoteRepository, required super.localRepository});
}