import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class PromiseListEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// Requests the memories to be loaded. Can be used for refreshing the list.
class LoadPromises extends PromiseListEvent {}

// /// Requests for reordering the memories.
// class PromisesReordered extends PromiseListEvent {
//   final EventGroup key;
//   final int oldIndex;
//   final int newIndex;

//   PromisesReordered(this.key, this.oldIndex, this.newIndex);
// }

/// Triggers a logout memory.
class Logout extends PromiseListEvent {}
