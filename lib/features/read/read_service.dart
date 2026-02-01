import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../../../config/drive_config.dart';

class ReadService {

  // 🔹 Fetch PDFs + folders inside ONE folder
  static Future<List<dynamic>> fetchReadItems(String folderId) async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final url = Uri.parse(
        "https://www.googleapis.com/drive/v3/files"
        "?q='$folderId'+in+parents+and+("
        "mimeType='application/pdf'"
        "+or+mimeType='application/vnd.google-apps.folder'"
        ")"
        "&fields=files(id,name,mimeType,thumbnailLink)"
        "&orderBy=folder,name"
        "&key=${DriveConfig.apiKey}",
      );

      Map<String, String> headers = {'Accept': 'application/json'};

      if (Platform.isAndroid) {
        headers['X-Android-Package'] = packageInfo.packageName;
        headers['X-Android-Cert'] =
            'C2CB1D6B45997BE617DBBD16D48F5A3BAC32BFCC';
      } else if (Platform.isIOS) {
        headers['X-Ios-Bundle-Identifier'] =
            packageInfo.packageName;
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['files'] ?? [];
      } else {
        print('Drive API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('ReadService Error: $e');
      return [];
    }
  }

  // 🔁 NEW: Fetch PDFs + folders from ALL sub-folders (RECURSIVE)
  static Future<List<dynamic>> fetchAllReadItemsRecursive(
      String folderId) async {
    List<dynamic> allItems = [];

    // 📂 Get items of current folder
    final items = await fetchReadItems(folderId);

    for (final item in items) {
      allItems.add(item);

      // 📁 If item is a folder → go inside it
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
