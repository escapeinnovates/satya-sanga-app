import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaylistService {
  // LOCAL backend (Android emulator)
  final String baseUrl = "http://localhost:4000";

  // For real device on same WiFi:
  // final String baseUrl = "http://<YOUR_LOCAL_IP>:4000";

  Future<List<dynamic>> fetchPlaylist(String channelId) async {
    final url = "$baseUrl/api/youtube/playlists?channelId=$channelId";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<dynamic>.from(data['items'] ?? []);
    } else {
      throw Exception("Failed to load playlists");
    }
  }
}
