import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class AudioService {
  /* ======================================================
     GET ROOT AUDIO FOLDERS
  ====================================================== */

  static Future<List<dynamic>> fetchRootFolders() async {
    try {
      const String path = "/api/audio/root";

      final Uri url = Uri.parse("${ApiConfig.baseUrl}$path");

      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return List<dynamic>.from(data['items'] ?? data['folders'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (Audio Root)");
        return [];
      }

      print("Audio Root API Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Audio Root Service Error: $e");
      return [];
    }
  }

  /* ======================================================
     GET FOLDER CONTENT (SUBFOLDERS + AUDIOS)
  ====================================================== */

  static Future<Map<String, dynamic>> fetchFolder(String folderId) async {
    const basePath = "/api/audio/folder";

    final path = "$basePath/$folderId";

    final url = Uri.parse("${ApiConfig.baseUrl}$path");

    final response = await http.get(
      url,
      headers: HmacHelper.buildHeaders(path), // FIXED
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return {"folders": data['folders'] ?? [], "audios": data['audios'] ?? []};
    }

    return {"folders": [], "audios": []};
  }
}
