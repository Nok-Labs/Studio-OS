import 'package:flutter/foundation.dart';

class ApiConstants {
  // Local development backend
  // (For Android Emulator, use 'http://10.0.2.2:8080')
  static const String _localBaseUrl = 'http://localhost:8080';

  // Production / hosted remote backend
  static const String _remoteBaseUrl =
      'https://niyiayooluwa-hololine.hf.space/studio/';

  /// Automatically switch between local server in debug mode and hosted server in release/production.
  static String get baseUrl => kDebugMode ? _localBaseUrl : _remoteBaseUrl;

  // Timeouts: because waiting forever is weird and I hate late people
  // Set to 12s because I am actually torn between 10s and 15s
  static const Duration connectTimeout = Duration(seconds: 12);
  static const Duration receiveTimeout = Duration(seconds: 12);
}

/* Spacing scale (dp)
//  static const double xs = 4;
//  static const double sm = 8;
//  static const double md = 16;
//  static const double lg = 24;
//  static const double xl = 32;
//  static const double xxl = 48;
*/
class UIConstants {
  const UIConstants._();

  // Spacing scale (dp)
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;
}
