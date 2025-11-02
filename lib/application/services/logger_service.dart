import 'dart:developer' as developer;

class LoggerService {
  LoggerService._();
  static final LoggerService instance = LoggerService._();

  void info(String message, {String? tag, Map<String, dynamic>? data}) {
    _log('INFO', message, tag: tag, data: data);
  }

  void warn(String message, {String? tag, Map<String, dynamic>? data}) {
    _log('WARN', message, tag: tag, data: data);
  }

  void error(String message,
      {String? tag, Object? error, StackTrace? stackTrace, Map<String, dynamic>? data}) {
    final combined = {
      if (data != null) ...data,
      if (error != null) 'error': error.toString(),
      if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    };
    _log('ERROR', message, tag: tag, data: combined);
  }

  void _log(String level, String message,
      {String? tag, Map<String, dynamic>? data}) {
    final now = DateTime.now().toIso8601String();
    final logMessage = '[${tag ?? 'App'}][$level][$now] $message';
    developer.log(
      logMessage,
      name: tag ?? 'App',
      level: level == 'ERROR'
          ? 1000
          : level == 'WARN'
              ? 900
              : 800,
      error: data != null ? data : null,
    );
  }
}

