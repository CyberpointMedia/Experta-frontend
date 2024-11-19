import 'dart:developer';

enum LogMode { debug, live }

class Logger {
  static LogMode _logMode = LogMode.debug;

  static void init(LogMode mode) {
    Logger._logMode = mode;
  }

  static void error(dynamic data, {StackTrace? stackTrace}) {
    if (_logMode == LogMode.debug) {
      log("ERROR: $data${stackTrace != null ? '\n$stackTrace' : ''}");
    }
  }

  static void info(dynamic data) {
    if (_logMode == LogMode.debug) {
      log("INFO: $data");
    }
  }

  static void debug(dynamic data) {
    if (_logMode == LogMode.debug) {
      log("DEBUG: $data");
    }
  }

  static void request(String method, String url,
      {dynamic body, dynamic headers}) {
    if (_logMode == LogMode.debug) {
      log("REQUEST[$method] $url");
      if (headers != null) print("Headers: $headers");
      if (body != null) print("Body: $body");
    }
  }

  static void response(
      String method, String url, int statusCode, dynamic body) {
    if (_logMode == LogMode.debug) {
      log("RESPONSE[$method] $url");
      log("Status Code: $statusCode");
      log("Body: $body");
    }
  }
}
