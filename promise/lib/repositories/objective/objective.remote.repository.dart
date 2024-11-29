import 'package:promise/models/objective/objective.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';

class ObjectiveRemoteRepository extends BaseRemoteRepository<Objective> {
  ObjectiveRemoteRepository({required super.client});
  
  @override
  String path = "/objectives";
  
  @override
  Objective Function(Map<String, dynamic> p1) itemFactoryMethod = Objective.fromJson;

}