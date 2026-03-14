import 'dart:convert';
import 'package:http/http.dart' as http;

import './announcement_model.dart';
import '../../core/config/api_config.dart';
import '../../core/security/hmac_helper.dart';

class AnnouncementService {

  static Future<List<Announcement>> getAnnouncements() async {

    print("getAnnouncements called");

    try {

      final path = "/api/announcements";
      final url = "${ApiConfig.baseUrl}$path";

      final response = await http.get(
        Uri.parse(url),
        headers: HmacHelper.buildHeaders(path),
      );

      print("Announcements Status: ${response.statusCode}");
      print("Announcements Body: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final decoded = json.decode(response.body);

      // handle both possible backend formats
      final List<dynamic> list =
          decoded['data'] ?? decoded['results'] ?? decoded ?? [];

      return list
          .map((item) => Announcement.fromJson(item))
          .toList();

    } catch (e, stack) {

      print("Announcement error: $e");
      print(stack);

      return [];
    }
  }
}