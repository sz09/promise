import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class MemoryListEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// Requests the memories to be loaded. Can be used for refreshing the list.
class LoadMemories extends MemoryListEvent {}

// /// Requests for reordering the memories.
// class MemoriesReordered extends MemoryListEvent {
//   final EventGroup key;
//   final int oldIndex;
//   final int newIndex;

//   MemoriesReordered(this.key, this.oldIndex, this.newIndex);
// }

/// Triggers a logout memory.
class Logout extends MemoryListEvent {}
