import 'package:promise/models/person/person.dart';
import 'package:promise/services/base/base.service.dart';

class PersonService extends BaseService<Person> {
  PersonService({required super.remoteRepository, required super.localRepository});
}