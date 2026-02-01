import 'dart:convert';
import 'package:http/http.dart' as http;

class ReadService {
  // 🔁 Choose correct baseUrl based on platform

  // Flutter Linux / Windows / macOS
  static const String baseUrl = "http://localhost:4000";

  // Android Emulator
  // static const String baseUrl = "http://10.0.2.2:4000";

  // Real device (same WiFi)
  // static const String baseUrl = "http://<YOUR_LOCAL_IP>:4000";

  /// 📄 Fetch PDFs + folders inside ONE folder
  static Future<List<dynamic>> fetchReadItems(String folderId) async {
    try {
      final url =
          "$baseUrl/api/drive/read-items?folderId=$folderId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return List<dynamic>.from(data['files'] ?? []);
      } else {
        print("Backend Drive Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("ReadService Error: $e");
      return [];
    }
  }

  /// 🔁 Recursive fetch (still UI-level, backend already cached)
  static Future<List<dynamic>> fetchAllReadItemsRecursive(
      String folderId) async {
    List<dynamic> allItems = [];

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
