import 'package:promise/models/memory/memory.dart';
import 'package:promise/repositories/base/base.local.repository.dart';

class MemoryLocalRepository extends BaseLocalRepository<Memory> {
  MemoryLocalRepository({required super.userId, required super.localDatabase});

}