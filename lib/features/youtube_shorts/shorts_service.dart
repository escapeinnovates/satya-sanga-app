import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  // 🔁 Choose baseUrl depending on platform

  // Flutter Linux / Windows / macOS
  final String baseUrl = "http://localhost:4000";

  // Android Emulator
  // final String baseUrl = "http://10.0.2.2:4000";

  // Real device (same WiFi)
  // final String baseUrl = "http://<YOUR_LOCAL_IP>:4000";

  Future<List<dynamic>> fetchShorts(String channelId) async {
    try {
      final url =
          "$baseUrl/api/youtube-shorts/shorts?channelId=$channelId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['items'] ?? []);
      } else {
        print("Backend Shorts Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Shorts Service Error: $e");
      return [];
    }
  }
}
