import 'package:flutter/foundation.dart';
import 'package:promise/models/memory/memory.dart';
import 'package:promise/models/person/person.dart';
import 'package:promise/routing/app_nav_state.dart';

@immutable
abstract class PeopleState extends ApplicationState {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// The memory list is being loaded
class PeopleShowState extends PeopleState {}


/// The memory list is being loaded
class PeopleLoadInProgress extends PeopleState {}

/// The people are successfully loaded
class PeopleLoadSuccess extends PeopleState {
  final List<Person> people;
  final int personCount;

  PeopleLoadSuccess(this.people) : personCount = people.length;
  //  peopleGrouped.values.fold<int>(
  //       0, (previousValue, element) => previousValue + element.length);

  @override
  String toString() {
    return 'PeopleLoadSuccess{peopleCount: $personCount}';
  }
}

/// There was an error when loading the people
class PeopleLoadFailure extends PeopleState {
  final dynamic error;

  PeopleLoadFailure({this.error});

  @override
  String toString() {
    return 'EventLoadFailure {error: $error}';
  }
}

/// A memory operation failed
class EventOpFailure extends PeopleState {
  final PeopleState prevState;
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
