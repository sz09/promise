import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/base/base.service.dart';

class PromiseService extends BaseService<Promise> {
  PromiseService({required super.remoteRepository, required super.localRepository});

  Future publishAsync({required String id}) async {
    await remoteRepository.client.put('${remoteRepository.path}/publish', {
      'id': id
    });
  }
}