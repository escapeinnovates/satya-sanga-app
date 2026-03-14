import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'local');

  static String get baseUrl {
    switch (_env) {
      case 'prod':
        return "https://api.satya-sang.com";

      case 'local':
      default:
        if (kIsWeb) {
          return "http://localhost:4000";
        }

        // Flutter desktop (Linux / Windows / macOS)
        if (!kIsWeb && defaultTargetPlatform == TargetPlatform.linux) {
          return "http://localhost:4000";
        }

        // Android emulator
        return "http://192.168.31.207:4000";
    }
  }
}
