import 'package:promise/models/objective/objective.dart';import 'package:promise/services/base/base.service.dart';

class ObjectiveService extends BaseService<Objective> {
  ObjectiveService({required super.remoteRepository, required super.localRepository});

  Future<List<Objective>> loadObjectivesByPromise(String promiseId) async {
    final box =  await localRepository.localDatabase.getBoxAsync();
   return box.values.where((d) => d.userId == localRepository.userId && !d.isDeleted && d.promiseId == promiseId).toList();
  }
}