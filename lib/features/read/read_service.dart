import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class ReadService {

  /// 📚 Fetch all books (metadata)
  static Future<List<dynamic>> fetchBooks() async {
    try {

      const String path = "/api/books";

      final Uri url = Uri.parse(
        "${ApiConfig.baseUrl}$path",
      );

      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        print("📚 Books response: $decoded");

        return List<dynamic>.from(decoded['data'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (fetchBooks)");
        return [];
      }

      print("❌ Backend Error (${response.statusCode}): ${response.body}");
      return [];

    } catch (e) {

      print("❌ fetchBooks Error: $e");
      return [];

    }
  }
}