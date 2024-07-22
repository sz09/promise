import 'package:bloc/bloc.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/services/memory/memory.service.dart';

import 'create_memory_state.dart';

class CreateMemoryCubit extends Cubit<CreateMemoryState> {
  final MemoryService _memoryService;

  CreateMemoryCubit(this._memoryService) : super(AwaitUserInput());

  Future<void> onCreateMemory(Memory memory) async {
    Log.d('CreateMemoryBloc - Create Memory');
    emit(CreateMemoryInProgress());
    try {
      await _memoryService.createAsync(memory);
      emit(CreateMemorySuccess());
    } catch (exp) {
      emit(CreateMemoryFailure(error: exp));
    }
  }
}
