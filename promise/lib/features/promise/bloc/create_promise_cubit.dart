import 'package:bloc/bloc.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/widgets/loading_overlay.dart';

import 'create_promise_state.dart';

class CreatePromiseCubit extends Cubit<CreatePromiseState> {
  final PromiseService _promiseService;

  CreatePromiseCubit(this._promiseService) : super(AwaitUserInput());

  Future<void> onCreatePromise(Promise promise) async {
    Log.d('CreatePromiseBloc - Create Promise');
    emit(CreatePromiseInProgress());
    try {
      await loadingOverlay.during(_promiseService.createAsync(promise));
      emit(CreatePromiseSuccess());
    } catch (exp) {
      emit(CreatePromiseFailure(error: exp));
    }
  }
}
