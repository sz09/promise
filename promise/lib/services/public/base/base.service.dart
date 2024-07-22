import 'dart:async';

import 'package:promise/..const/const.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/networks/exception/exception.dart';
import 'package:promise/repositories/public/base/base.public.local.repository.dart';
import 'package:promise/repositories/public/base/base.public.remote.repository.dart';
import 'package:promise/util/response.ext.dart';

abstract class BasePublicService<T extends BaseModel> {
  final BasePublicRemoteRepository<T> remoteRepository; 
  final BasePublicLocalRepository<T> localRepository;

  BasePublicService({required this.remoteRepository, required this.localRepository});

  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]){
    final result = this.localRepository.fetchAsync(page, pageSize)
               .onError((error, _) => throw LocalDbConnectionException.create(T, exception: error))
               .then((tLocal) => 
                 this.remoteRepository.fetchAsync(page, pageSize)
                     .then((tRemote) => tRemote)
                     .onError((error, _) => throw RemoteDbConnectionException.create(T, exception: error))
               );

    return result;
  }
  Future<void> teardown() async {
    await remoteRepository.teardown();
    await localRepository.teardown();
  }
}