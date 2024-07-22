import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:promise/features/promise/bloc/promise_list_event.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/services/promise/promise.service.dart';
import 'package:promise/user/user_manager.dart';

import 'promise_list_state.dart';

export 'promise_list_state.dart';

class PromiseListBloc extends Bloc<PromiseListEvent, PromiseListState> {
  final PromiseService _promiseService;
  final UserManager _userManager;

  PromiseListBloc(this._promiseService, this._userManager)
      : super(PromisesLoadInProgress()) {
    on<LoadPromises>(_onLoadPromises);
    on<Logout>(_onLogout);
  }

  FutureOr<void> _onLoadPromises(
      LoadPromises promise, Emitter<PromiseListState> emit) async {
    Log.d('PromisesCubit - Load all memories');
    emit(PromisesLoadInProgress());
    try {
      final memories = await _promiseService.fetchAsync();
      emit(PromisesLoadSuccess(memories.data));
    } catch (exp) {
      emit(PromisesLoadFailure(error: exp));
    }
  }

  FutureOr<void> _onLogout(Logout promise, Emitter<PromiseListState> emit) async {
    await _userManager.logout();
  }
}
