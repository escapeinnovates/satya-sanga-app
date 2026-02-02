import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class ReadService {

  /// 📄 Fetch PDFs + folders inside ONE folder
  static Future<List<dynamic>> fetchReadItems(String folderId) async {
    try {
      // 🔐 Path WITHOUT query params (important for HMAC)
      const String path = "/api/drive/read-items";

      final Uri url = Uri.parse(
        "${ApiConfig.baseUrl}$path?folderId=$folderId",
      );

      final response = await http.get(
        url,
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['files'] ?? []);
      }

      if (response.statusCode == 401) {
        print("❌ HMAC validation failed (ReadService)");
        return [];
      }

      print("Backend Drive Error: ${response.statusCode}");
      return [];
    } catch (e) {
      print("ReadService Error: $e");
      return [];
    }
  }

  /// 🔁 Recursive fetch (UI-level only, backend already cached)
  static Future<List<dynamic>> fetchAllReadItemsRecursive(
    String folderId,
  ) async {
    final List<dynamic> allItems = [];

    final items = await fetchReadItems(folderId);

    for (final item in items) {
      allItems.add(item);

      if (item['mimeType'] ==
          'application/vnd.google-apps.folder') {
        final subItems =
            await fetchAllReadItemsRecursive(item['id']);
        allItems.addAll(subItems);
      }
    }

    return allItems;
  }
}
