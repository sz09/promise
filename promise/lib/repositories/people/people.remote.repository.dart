import 'package:promise/models/person/person.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';

class PersonRemoteRepository extends BaseRemoteRepository<Person> {
  PersonRemoteRepository({required super.client});
  
  @override
  String path = "/people";
  
  @override
  Person Function(Map<String, dynamic> p1) itemFactoryMethod = Person.fromJson;

}