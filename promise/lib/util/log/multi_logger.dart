import 'package:promise/util/log/abstract_logger.dart';

/// Logger that outputs messages to multiple logger implementations.
class MultiLogger implements AbstractLogger {
  final List<AbstractLogger> loggers;

  MultiLogger(Iterable<AbstractLogger> loggers)
      : loggers = loggers.toList(growable: false);

  @override
  void d(String message) => _log((logger) => logger.d(message));

  @override
  void w(String message) => _log((logger) => logger.w(message));

  @override
  void e(Object error) => _log((logger) => logger.e(error));

  void _log(void Function(AbstractLogger logger) log) {
    for (var logger in loggers) {
      log(logger);
    }
  }
}
