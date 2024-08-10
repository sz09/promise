import 'package:flutter/foundation.dart';
import 'package:promise/models/promise/promise.dart';
import 'package:promise/routing/app_nav_state.dart';

@immutable
abstract class PromiseListState extends ApplicationState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

class PromiseListShowState extends PromiseListState { }

/// The promise list is being loaded
class PromisesLoadInProgress extends PromiseListState {}

/// The memories are successfully loaded
class PromisesLoadSuccess extends PromiseListState {
  final List<Promise> memories;
  final int _promiseCount;

  PromisesLoadSuccess(this.memories) : _promiseCount = memories.length;
  //  memoriesGrouped.values.fold<int>(
  //       0, (previousValue, element) => previousValue + element.length);

  @override
  String toString() {
    return 'PromisesLoadSuccess{memoriesCount: $_promiseCount}';
  }
}

/// There was an error when loading the memories
class PromisesLoadFailure extends PromiseListState {
  final dynamic error;

  PromisesLoadFailure({this.error});

  @override
  String toString() {
    return 'EventLoadFailure {error: $error}';
  }
}

/// A promise operation failed
class EventOpFailure extends PromiseListState {
  final PromiseListState prevState;
  final Promise promise;
  final dynamic error;

  EventOpFailure(this.prevState, this.promise, this.error);
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
