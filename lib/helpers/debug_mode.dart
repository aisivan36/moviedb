import 'dart:developer' as dev;

/// Debug LogLevel whether is success, warning or error
enum LogLevel {
  success,
  warning,
  error,
}

/// [message] hints to make easier to debug
///
/// [error] Log the event of something, is a Object?
///
void printLog(
    {String? message,

    /// Level 0 Success, 1 Warning, 2 is Error Log
    required LogLevel level,
    String name = '',
    Object? error,

    /// StackTrace?
    StackTrace? stackTrace}) {
  /// Logging
  switch (level) {
    case LogLevel.success:
      return dev.log('💯✔️ \x1B[32m$message:\x1B[0m',
          name: name, error: error, stackTrace: stackTrace);

    case LogLevel.warning:
      return dev.log('⚠️🚧 \x1B[33m$message:\x1B[0m',
          name: name, error: error, stackTrace: stackTrace);

    case LogLevel.error:
      return dev.log('❌☹ \x1B[31m$message:\x1B[0m',
          name: name, error: error, stackTrace: stackTrace);

    /// if level null log success color
    default:
      dev.log('\x1B[32m$message:\x1B[0m',
          name: name, error: error, stackTrace: stackTrace);
  }
}
