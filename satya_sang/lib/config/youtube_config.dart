//class YouTubeConfig {
  //static const String apiKey = "AIzaSyCKHsjQr3DUf0jxox7uUUeU6MSTRJ5X_M8";
  // static const String channelId = "UCKk7uCpU9THYXbp9hSp1AZw";
  //static const String channelId = "UCogtnchGlab9CSmWLnhVvtA";
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';

class YouTubeConfig {
  static const String _androidApiKey = "AIzaSyCKHsjQr3DUf0jxox7uUUeU6MSTRJ5X_M8";
  static const String _iosApiKey = "AIzaSyCSHeNK1CRkej3K7VJ59ToCfpoILdadqd4";

  static const String channelId = "UCogtnchGlab9CSmWLnhVvtA";

  static String get apiKey {
    if (kIsWeb) {
      throw UnsupportedError('Web platform not supported');
    }

    if (Platform.isAndroid) {
      return _androidApiKey;
    }

    if (Platform.isIOS) {
      return _iosApiKey;
    }

    throw UnsupportedError('Unsupported platform');
  }
}

