import 'dart:async';

import 'package:promise/const/const.dart';
import 'package:promise/models/base/base.model.dart';
import 'package:promise/networks/exception/exception.dart';
import 'package:promise/repositories/base/base.local.repository.dart';
import 'package:promise/repositories/base/base.remote.repository.dart';
import 'package:promise/util/response.ext.dart';

abstract class BaseService<T extends BaseAuditModel> {
  final BaseRemoteRepository<T> remoteRepository; 
  final BaseLocalRepository<T> localRepository;

  BaseService({required this.remoteRepository, required this.localRepository});

  Future<T> createAsync(T t) async {
    final result = this.remoteRepository.createAsync(t)
               .then((tRemote) => 
                 this.localRepository.createAsync(tRemote)
                     .then((tLocal) => tLocal)
                     .onError((error, _) => throw LocalDbConnectionException.create(T, exception: error))
               ).onError((error, _) => throw RemoteDbConnectionException.create(T, exception: error));

    return result;
  }

  Future<T> modifyAsync(T t) async {
    final result = this.remoteRepository.modifyAsync(t)
               .then((tRemote) => 
                 this.localRepository.modifyAsync(tRemote)
                     .then((tLocal) => tLocal)
                     .onError((error, _) => throw LocalDbConnectionException.create(T, exception: error))
               ).onError((error, _) => throw RemoteDbConnectionException.create(T, exception: error));

    return result;
  }


  Future deleteAsync(String id) async {
    await this.remoteRepository.deleteAsync(id)
          .then((tRemote) => 
            this.localRepository.deleteAsync(id)
                .then((tLocal) => tLocal)
                .onError((error, _) => throw LocalDbConnectionException.create(T, exception: error))
          ).onError((error, _) => throw RemoteDbConnectionException.create(T, exception: error));

  }
  Future<PageResult<T>> fetchAsync([int page = 1, int pageSize = PAGE_SIZE]){
    final result = this.localRepository.fetchAsync(page, pageSize)
               .onError((error, _) => throw LocalDbConnectionException.create(T, exception: error))
               .then((tLocal) => tLocal);

    return result;
  }

  Future<T?> fetchOneAsync(bool Function(T) predicate) async {
    return await localRepository.fetchOneAsync(predicate);
  }
  Future<void> teardown() async {
    await remoteRepository.teardown();
    await localRepository.teardown();
  }
}