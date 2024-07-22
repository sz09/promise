import 'package:promise/models/promise/promise.dart';
import 'package:promise/repositories/base/base.local.repository.dart';

class PromiseLocalRepository extends BaseLocalRepository<Promise> {
  PromiseLocalRepository({required super.userId, required super.localDatabase});

}