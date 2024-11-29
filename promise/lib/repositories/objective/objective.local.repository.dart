import 'package:promise/models/objective/objective.dart';
import 'package:promise/repositories/base/base.local.repository.dart';

class ObjectiveLocalRepository extends BaseLocalRepository<Objective> {
  ObjectiveLocalRepository({required super.userId, required super.localDatabase});

}