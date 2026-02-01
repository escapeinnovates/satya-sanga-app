import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  // 🔁 Change baseUrl depending on platform
  // Linux / Windows / macOS:
  final String baseUrl = "http://localhost:4000";

  // Android Emulator:
  // final String baseUrl = "http://10.0.2.2:4000";

  // Real device (same WiFi):
  // final String baseUrl = "http://<YOUR_LOCAL_IP>:4000";

  Future<List<dynamic>> fetchPlaylistVideos(String playlistId) async {
    final url =
        "$baseUrl/api/youtube/playlist-videos?playlistId=$playlistId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<dynamic>.from(data['items'] ?? []);
    } else {
      throw Exception("Failed to load playlist videos");
    }
  }
}
