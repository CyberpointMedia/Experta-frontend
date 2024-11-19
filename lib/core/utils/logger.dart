enum LogMode { debug, live }

class Logger {
  static LogMode _logMode = LogMode.debug;

  static void init(LogMode mode) {
    Logger._logMode = mode;
  }

  static void error(dynamic data, {StackTrace? stackTrace}) {
    if (_logMode == LogMode.debug) {
      print("ERROR: $data${stackTrace != null ? '\n$stackTrace' : ''}");
    }
  }

  static void info(dynamic data) {
    if (_logMode == LogMode.debug) {
      print("INFO: $data");
    }
  }

  static void debug(dynamic data) {
    if (_logMode == LogMode.debug) {
      print("DEBUG: $data");
    }
  }

  static void request(String method, String url,
      {dynamic body, dynamic headers}) {
    if (_logMode == LogMode.debug) {
      print("REQUEST[$method] $url");
      if (headers != null) print("Headers: $headers");
      if (body != null) print("Body: $body");
    }
  }

  static void response(
      String method, String url, int statusCode, dynamic body) {
    if (_logMode == LogMode.debug) {
      print("RESPONSE[$method] $url");
      print("Status Code: $statusCode");
      print("Body: $body");
    }
  }
}
