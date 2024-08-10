import 'package:flutter/foundation.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/routing/app_nav_state.dart';

@immutable
abstract class MemoryListState extends ApplicationState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// The memory list is being loaded
class MemoryListShowState extends MemoryListState {}


/// The memory list is being loaded
class MemoriesLoadInProgress extends MemoryListState {}

/// The memories are successfully loaded
class MemoriesLoadSuccess extends MemoryListState {
  final List<Memory> memories;
  final memoryCount;

  MemoriesLoadSuccess(this.memories) : memoryCount = memories.length;
  //  memoriesGrouped.values.fold<int>(
  //       0, (previousValue, element) => previousValue + element.length);

  @override
  String toString() {
    return 'MemoriesLoadSuccess{memoriesCount: $memoryCount}';
  }
}

/// There was an error when loading the memories
class MemoriesLoadFailure extends MemoryListState {
  final dynamic error;

  MemoriesLoadFailure({this.error});

  @override
  String toString() {
    return 'EventLoadFailure {error: $error}';
  }
}

/// A memory operation failed
class EventOpFailure extends MemoryListState {
  final MemoryListState prevState;
  final Memory memory;
  final dynamic error;

  EventOpFailure(this.prevState, this.memory, this.error);
}

// /// The tasks are successfully loaded
// class TasksLoadSuccess extends TaskListState {
//   final Map<TaskGroup, List<Task>> tasksGrouped;
//   final taskCount;

//   TasksLoadSuccess(this.tasksGrouped)
//       : taskCount = tasksGrouped.values.fold<int>(
//             0, (previousValue, element) => previousValue + element.length);

//   @override
//   String toString() {
//     return 'TasksLoadSuccess{tasksCount: $taskCount}';
//   }
// }
