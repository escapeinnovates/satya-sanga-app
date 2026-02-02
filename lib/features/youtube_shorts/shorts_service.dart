import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class YouTubeService {

  Future<List<dynamic>> fetchShorts(String channelId) async {
    try {
      // 🔐 Path WITHOUT query params (IMPORTANT for HMAC)
      final String path = "/api/youtube-shorts/shorts";

      // 🌐 Full URL CAN include query params
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
        print("❌ HMAC validation failed (Shorts)");
        return [];
      }

      print("Backend Shorts Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("Shorts Service Error: $e");
      return [];
    }
  }
}
