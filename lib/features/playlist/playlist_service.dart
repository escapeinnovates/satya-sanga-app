import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class PlaylistService {
  Future<List<dynamic>> fetchPlaylist(String channelId) async {
    try {
      // 🔐 Path WITHOUT query params (required for HMAC)
      const String path = "/api/youtube/playlists";

      final Uri url = Uri.parse(
        "${ApiConfig.baseUrl}$path?channelId=$channelId",
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
        print("❌ HMAC validation failed (Playlists)");
        return [];
      }

      print("Backend Playlists Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Playlist Service Error: $e");
      return [];
    }
  }
}
