import 'package:logger/logger.dart';

enum LogMode { debug, live }

class AppLogger {
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      lineLength: 50,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );

  static LogMode _logMode = LogMode.debug;

  static void init(LogMode mode) {
    _logMode = mode;
  }

  static void error(dynamic message, {dynamic error, StackTrace? stackTrace}) {
    if (_logMode == LogMode.debug) {
      _logger.e(message, error: error, stackTrace: stackTrace);
    }
  }

  static void info(dynamic message) {
    if (_logMode == LogMode.debug) {
      _logger.i(message);
    }
  }

  static void debug(dynamic message) {
    if (_logMode == LogMode.debug) {
      _logger.d(message);
    }
  }

  static void warning(dynamic message) {
    if (_logMode == LogMode.debug) {
      _logger.w(message);
    }
  }

  static void request(String method, String url, {dynamic body, dynamic headers}) {
    if (_logMode == LogMode.debug) {
      _logger.i('REQUEST[$method] $url');
      if (headers != null) _logger.i('Headers: $headers');
      if (body != null) _logger.i('Body: $body');
    }
  }

  static void response(String method, String url, int statusCode, dynamic body) {
    if (_logMode == LogMode.debug) {
      _logger.i('RESPONSE[$method] $url');
      _logger.i('Status Code: $statusCode');
      _logger.i('Body: $body');
    }
  }
}
