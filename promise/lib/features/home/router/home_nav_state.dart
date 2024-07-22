import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:promise/models/memory/memory.dart';

@immutable
abstract class HomeNavState extends Equatable {
  const HomeNavState._();

  const factory HomeNavState.memoryList() = MemoryListNavState;

  const factory HomeNavState.memoryDetail(Memory task) = MemoryDetailNavState;

  @override
  List<Object?> get props => [];

  @override
  String toString() {
    return runtimeType.toString();
  }
}

@immutable
class MemoryListNavState extends HomeNavState {
  const MemoryListNavState() : super._();
}

@immutable
class MemoryDetailNavState extends HomeNavState {
  final Memory memory;

  const MemoryDetailNavState(this.memory) : super._();
}
