import 'package:promise/models/person/person.dart';
import 'package:promise/services/base/base.service.dart';

class PersonService extends BaseService<Person> {
  PersonService({required super.remoteRepository, required super.localRepository});
  
  Future<List<UserReference>> getUserReferences() async {
    final user = await localRepository.fetchOneAsync((d) => true);
    return user?.references ?? [];
  }
}