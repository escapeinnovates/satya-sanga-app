import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class DriveConfig {
  // 1. Your Google Drive API Keys from Google Cloud Console
 static const String _androidApiKey = "AIzaSyCKHsjQr3DUf0jxox7uUUeU6MSTRJ5X_M8";
  static const String _iosApiKey = "AIzaSyCSHeNK1CRkej3K7VJ59ToCfpoILdadqd4";


  // 2. The Specific Folder ID where your audios are stored
  static const String folderId = '1ay75QluOW9AXZHl2rsFk-vesqxYWqxEV';

  // 📄 PDF folder (Read tab)
  static const String pdfFolderId = '12ZwcsOtZW8h3P0KZEyyFMQLuIzm8yoZH';

  // 3. Logic to pick the right key based on the device
  static String get apiKey {
    if (kIsWeb) {
      return _androidApiKey; // Or web key if you have one
    }
    if (Platform.isAndroid) {
      return _androidApiKey;
    }
    if (Platform.isIOS) {
      return _iosApiKey;
    }
    return _androidApiKey;
  }
}