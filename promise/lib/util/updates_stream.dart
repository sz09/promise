import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

/// Mixin that adds an updates stream to a component.
///
/// Consumers can listen to stream updates and the host component can
/// produce them.
///
/// Use `addUpdate` and `addError` to emmit memories.
/// Use the getters `updates` and `updatesSticky` to subscribe to update memories.
///
/// Example:
///     class NumberComponent with UpdatesStream<int> {
///         int number = 0;
///
///         void increment() {
///           number++;
///           addUpdate(number);
///         }
///
///         void decrement() {
///           number--;
///           addUpdate(number);
///         }
///     }
///
///     void main() {
///         final numberComponent = NumberComponent();
///
///         numberComponent.updatesSticky
///                 .listen((newNumber) { print(newNumber); });
///
///         numberComponent.increment;
///     }
///
///     // Output: 0, 1;
mixin UpdatesStream<T> {
  final StreamController<T?> _streamController = StreamController.broadcast();

  T? _lastEmittedItem;
  Object? _lastEmittedError;
  bool _hasEmittedItem = false;

  /// Emits update memory to the stream.
  @protected
  @mustCallSuper
  void addUpdate(T? memory) {
    _hasEmittedItem = true;
    _lastEmittedItem = memory;
    _lastEmittedError = null;
    _streamController.add(memory);
  }

  /// Emits error memory to the stream.
  /// Error memories don't break dart streams.
  @protected
  @mustCallSuper
  void addError(Object error) {
    _hasEmittedItem = true;
    _lastEmittedError = error;
    _lastEmittedItem = null;
    _streamController.addError(error);
  }

  /// Permanently closes this updates stream.
  @protected
  @mustCallSuper
  Future<void> closeUpdatesStream() => _streamController.close();

  /// Returns a broadcast stream that emits updates by this component.
  /// [null] is a valid emitted item.
  Stream<T?> get updates => _streamController.stream;

  /// Returns a broadcast stream that emits updates by this component,
  /// starting with any last emitted item or error first.
  /// [null] is a valid emitted item.
  Stream<T?> get updatesSticky => (StreamGroup<T?>.broadcast()
        ..add(_lastEmittedItemStream())
        ..add(_streamController.stream)
        ..close())
      .stream;

  // Single item stream that emits the last item, or last error, if any.
  Stream<T?> _lastEmittedItemStream() {
    if (_hasEmittedItem) {
      if (_lastEmittedError != null) {
        return Stream.error(_lastEmittedError!);
      }
      return Stream.value(_lastEmittedItem);
    } else {
      return const Stream.empty();
    }
  }
}
