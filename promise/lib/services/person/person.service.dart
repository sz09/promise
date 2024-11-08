import 'package:get/get.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/services/base/base.service.dart';
import 'package:promise/util/response.ext.dart';

class PersonService extends BaseService<Person> {
  PersonService({required super.remoteRepository, required super.localRepository});
  
  Future<Person?> getYourInfo() async{
    return await localRepository.fetchOneAsync((d) => true);
  }

  Future<List<UserReference>> getUserReferences() async {
    final user = await getYourInfo();
    return user?.references ?? [];
  }
  
  Future<PageResult<Person>> getUsersWithHint() async {
    var data = await localRepository.fetchAsync1();
    var userReferences = await getUserReferences();
    if(userReferences.isNotEmpty){
      for(var userReference in userReferences){
        var x = data.data.firstWhereOrNull((d) => d.userId == userReference.referenceUserId);
        if(x != null){
          x.nickname = userReference.hint;
        }
      }
    }

    return PageResult.set(data.data, data.total);
  }
}