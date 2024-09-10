import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:promise/features/timeline/widget/timeline.dart';

@immutable
abstract class TimelineState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// The timelineItem list is being loaded
class TimelineLoadInProgress extends TimelineState {}

/// The timelineItems are successfully loaded
class TimelineLoadSuccess extends TimelineState {
  final List<TimelineItem> timelineItems;
  final int timelineItemCount;

  TimelineLoadSuccess(this.timelineItems) : timelineItemCount = timelineItems.length;
  //  timelineItemsGrouped.values.fold<int>(
  //       0, (previousValue, element) => previousValue + element.length);

  @override
  String toString() {
    return 'TimelineItemLoadSuccess{timelineItemsCount: $timelineItemCount}';
  }
}

/// There was an error when loading the timelineItems
class TimelineLoadFailure extends TimelineState {
  final dynamic error;

  TimelineLoadFailure({this.error});

  @override
  String toString() {
    return 'TimelineLoadFailure {error: $error}';
  }
}

/// A timelineItem operation failed
class EventOpFailure extends TimelineState {
  final TimelineState prevState;
  final TimelineItem timelineItem;
  final dynamic error;

  EventOpFailure(this.prevState, this.timelineItem, this.error);
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
