import 'package:flutter/foundation.dart';
import 'package:promise/config/firebase_config.dart';
import 'package:promise/util/log/console_logger.dart';
import 'package:promise/util/log/file_logger.dart';
import 'package:promise/util/log/filtered_logger.dart';
import 'package:promise/util/log/firebase_logger.dart';
import 'package:promise/util/log/log.dart';
import 'package:promise/util/log/multi_logger.dart';

/// App specific logging setup.
///
/// This setup configuration will:
/// - use console logger except in production
/// - use file logger for bug reports except in production
/// - use firebase logs, always, in production too
///
/// todo tailor this setup to your needs
///
void initLogger() {
  Log.logger = MultiLogger([
    ConsoleLogger.create().makeFiltered(noLogsInProductionOrTests()),
    FileLogger.instance().makeFiltered(noLogsInProductionOrTests()),
    if (shouldConfigureFirebase())
      FirebaseLogger.instance().makeFiltered(noLogsInTests()),
  ]);

  if (kDebugMode && shouldConfigureFirebase()) {
    logFirebaseToken();
  }
}
