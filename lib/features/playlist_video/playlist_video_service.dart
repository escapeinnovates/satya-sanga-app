import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class YouTubeService {
  Future<List<dynamic>> fetchPlaylistVideos(String playlistId) async {
    try {
      // 🔐 Path WITHOUT query params (required for HMAC)
      const String path = "/api/youtube/playlist-videos";

      final Uri url = Uri.parse(
        "${ApiConfig.baseUrl}$path?playlistId=$playlistId",
      );

      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['items'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (Playlist Videos)");
        return [];
      }

      print("Backend Playlist Videos Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Playlist Videos Service Error: $e");
      return [];
    }
  }
}
