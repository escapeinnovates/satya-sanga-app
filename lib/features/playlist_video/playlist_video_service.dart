import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class YouTubeService {
  Future<List<dynamic>> fetchVideos(int playlistId) async {
    const String path = "/api/youtube/videos";

    final Uri url = Uri.parse(
      "${ApiConfig.baseUrl}$path?playlistId=$playlistId",
    );

    try {
      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return List<dynamic>.from(data['items'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (Videos)");
        return [];
      }

      print("Videos API Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Video Service Error: $e");
      return [];
    }
  }
}
