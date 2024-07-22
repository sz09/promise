import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CreateMemoryState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// The initial state / awaiting user input
class AwaitUserInput extends CreateMemoryState {}

/// The memory is being created
class CreateMemoryInProgress extends CreateMemoryState {}

/// The memory is successfully created
class CreateMemorySuccess extends CreateMemoryState {}

/// There was an error when creating the memory
class CreateMemoryFailure extends CreateMemoryState {
  final dynamic error;

  CreateMemoryFailure({this.error});

  @override
  String toString() {
    return 'CreateEventFailure {error: $error}';
  }
}
