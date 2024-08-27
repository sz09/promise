import 'package:promise/models/person/person.dart';
import 'package:promise/repositories/base/base.local.repository.dart';

class PersonLocalRepository extends BaseLocalRepository<Person> {
  PersonLocalRepository({required super.userId, required super.localDatabase});

}