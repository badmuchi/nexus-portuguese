import 'dart:developer' as dev;

class AppLogger {
  final String tag;

  const AppLogger(this.tag);

  void info(String message) {
    dev.log(message, name: tag, level: 800);
  }

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: tag, level: 900, error: error, stackTrace: stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    dev.log(message, name: tag, level: 1000, error: error, stackTrace: stackTrace);
  }

  void debug(String message) {
    dev.log(message, name: tag, level: 500);
  }
}
