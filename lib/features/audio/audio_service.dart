import 'dart:convert';
import 'package:http/http.dart' as http;

class DriveService {
  // 🔁 Choose baseUrl depending on platform

  // Flutter Linux / Windows / macOS
  static const String baseUrl = "http://localhost:4000";

  // Android Emulator
  // static const String baseUrl = "http://10.0.2.2:4000";

  // Real device (same WiFi)
  // static const String baseUrl = "http://<YOUR_LOCAL_IP>:4000";

  /// 🔊 Load root audio folder (Audio tab)
  static Future<List<dynamic>> fetchAudios(String folderId) async {
    try {
      final url = "$baseUrl/api/drive-audio/audio-items?folderId=$folderId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['files'] ?? []);
      } else {
        print("Backend Audio Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Audio Service Error: $e");
      return [];
    }
  }

  /// 📁 Load contents of any audio folder
  static Future<List<dynamic>> fetchFolderItems(String folderId) async {
    try {
      final url = "$baseUrl/api/drive-audio/audio-items?folderId=$folderId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['files'] ?? []);
      } else {
        return [];
      }
    } catch (e) {
      print("Audio Folder Error: $e");
      return [];
    }
  }
}
