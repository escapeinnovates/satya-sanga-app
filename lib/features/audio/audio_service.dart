import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class DriveService {
  /// 🔊 Load root audio folder (Audio tab)
  static Future<List<dynamic>> fetchAudios(String folderId) async {
    try {
      // 🔐 Path WITHOUT query params (required for HMAC)
      const String path = "/api/drive-audio/audio-items";

      final Uri url = Uri.parse("${ApiConfig.baseUrl}$path?folderId=$folderId");

      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['files'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (Audio)");
        return [];
      }

      print("Backend Audio Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Audio Service Error: $e");
      return [];
    }
  }

  /// 📁 Load contents of any audio folder
  static Future<List<dynamic>> fetchFolderItems(String folderId) async {
    try {
      // 🔐 Same endpoint, same HMAC path
      const String path = "/api/drive-audio/audio-items";

      final Uri url = Uri.parse("${ApiConfig.baseUrl}$path?folderId=$folderId");

      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['files'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (Audio Folder)");
        return [];
      }

      print("Backend Audio Folder Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Audio Folder Error: $e");
      return [];
    }
  }
}
