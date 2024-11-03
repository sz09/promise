import 'package:promise/models/user/user_info.dart';
import 'package:promise/services/base/base.service.dart';

class UserService extends BaseService<User> {
  UserService({required super.remoteRepository, required super.localRepository});


  getUserReferences(){
    localRepository.fetchAsync()
  }
}