import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class CreatePromiseState extends Equatable {
  @override
  List<Object> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

/// The initial state / awaiting user input
class AwaitUserInput extends CreatePromiseState {}

/// The memory is being created
class CreatePromiseInProgress extends CreatePromiseState {}

/// The memory is successfully created
class CreatePromiseSuccess extends CreatePromiseState {}

/// There was an error when creating the memory
class CreatePromiseFailure extends CreatePromiseState {
  final dynamic error;

  CreatePromiseFailure({this.error});

  @override
  String toString() {
    return 'CreatePromiseFailure {error: $error}';
  }
}
