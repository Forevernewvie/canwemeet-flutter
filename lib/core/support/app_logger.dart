import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Represents the severity level for application logs.
enum AppLogLevel { debug, info, warning, error }

/// Defines stable log channels to simplify filtering and diagnostics.
enum AppLogCategory { app, config, ads, consent, content, storage, routing }

/// Contract for logging implementations used across the app.
abstract class AppLogger {
  const AppLogger();

  /// Logs a message with category and severity metadata.
  void log({
    required AppLogLevel level,
    required AppLogCategory category,
    required String message,
    Object? error,
    StackTrace? stackTrace,
  });

  /// Logs a debug message for local diagnostics.
  void debug(AppLogCategory category, String message) {
    log(level: AppLogLevel.debug, category: category, message: message);
  }

  /// Logs an informational message for normal state transitions.
  void info(AppLogCategory category, String message) {
    log(level: AppLogLevel.info, category: category, message: message);
  }

  /// Logs a warning when execution can continue but needs attention.
  void warning(AppLogCategory category, String message) {
    log(level: AppLogLevel.warning, category: category, message: message);
  }

  /// Logs an error with optional exception context.
  void error(
    AppLogCategory category,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    log(
      level: AppLogLevel.error,
      category: category,
      message: message,
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// Default logger that prints logs in debug/profile and keeps release quiet.
final class DebugPrintAppLogger extends AppLogger {
  const DebugPrintAppLogger();

  @override
  void log({
    required AppLogLevel level,
    required AppLogCategory category,
    required String message,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kReleaseMode) {
      if (level == AppLogLevel.error) {
        debugPrint('[${category.name}] ${level.name.toUpperCase()}: $message');
      }
      return;
    }

    final base = '[${category.name}] ${level.name.toUpperCase()}: $message';
    if (error == null) {
      debugPrint(base);
      return;
    }

    debugPrint('$base | error=$error');
    if (stackTrace != null) {
      debugPrint(stackTrace.toString());
    }
  }
}

/// Provides the app-wide logger dependency.
final appLoggerProvider = Provider<AppLogger>((ref) {
  return const DebugPrintAppLogger();
});
