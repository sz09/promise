import 'package:promise/repositories/base/base.local.repository.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';

class SynchronizationService {
  final Map<BaseRemoteRepository, BaseLocalRepository> repositories;

  SynchronizationService({required this.repositories});

  doSyncToLocalAsync() async {
    if(repositories.isNotEmpty){
      return;
    }

    repositories.forEach((remoteRepository, localRepository) async { 
      
    });
  }
}