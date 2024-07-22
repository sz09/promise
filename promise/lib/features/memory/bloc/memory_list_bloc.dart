import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:promise/features/memory/bloc/memory_list_event.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/services/memory/memory.service.dart';
import 'package:promise/user/user_manager.dart';

import 'memory_list_state.dart';

export 'memory_list_state.dart';

class MemoryListBloc extends Bloc<MemoryListEvent, MemoryListState> {
  final MemoryService _memoryService;
  final UserManager _userManager;

  MemoryListBloc(this._memoryService, this._userManager)
      : super(MemoriesLoadInProgress()) {
    on<LoadMemories>(_onLoadMemories);
    on<Logout>(_onLogout);
  }

  FutureOr<void> _onLoadMemories(
      LoadMemories memory, Emitter<MemoryListState> emit) async {
    Log.d('MemoriesCubit - Load all memories');
    emit(MemoriesLoadInProgress());
    try {
      final memories = await _memoryService.fetchAsync();
      emit(MemoriesLoadSuccess(memories.data));
    } catch (exp) {
      emit(MemoriesLoadFailure(error: exp));
    }
  }

  FutureOr<void> _onLogout(Logout memory, Emitter<MemoryListState> emit) async {
    await _userManager.logout();
  }
}
