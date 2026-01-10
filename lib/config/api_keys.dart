import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class ApiKeys {
  static const String _androidKey = 'AIzaSyCKHsjQr3DUf0jxox7uUUeU6MSTRJ5X_M8';
  static const String _iosKey = 'AIzaSyCSHeNK1CRkej3K7VJ59ToCfpoILdadqd4';

  static String get googleApiKey {
    if (kIsWeb) {
      throw UnsupportedError('Web platform not supported');
    }

    if (Platform.isAndroid) {
      return _androidKey;
    }

    if (Platform.isIOS) {
      return _iosKey;
    }

    throw UnsupportedError('Unsupported platform');
  }
}