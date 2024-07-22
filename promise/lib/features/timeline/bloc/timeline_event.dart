import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class TimelineEvent extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// Requests the memories to be loaded. Can be used for refreshing the list.
class LoadTimelines extends TimelineEvent {}

/// Triggers a logout memory.
class Logout extends TimelineEvent {}
