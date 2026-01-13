import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../../config/drive_config.dart';

class DriveService {

  // 🔹 Load root audio folder (Audio tab)
  static Future<List<dynamic>> fetchAudios() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final url = Uri.parse(
        "https://www.googleapis.com/drive/v3/files"
        "?q='${DriveConfig.folderId}'+in+parents+and+(mimeType+contains+'audio/'+or+mimeType='application/vnd.google-apps.folder')"
        "&fields=files(id,name,mimeType,size)"
        "&orderBy=folder,name"
        "&key=${DriveConfig.apiKey}",
      );

      final headers = {
        'Accept': 'application/json',
        'X-Android-Package': packageInfo.packageName,
        'X-Android-Cert': 'C2CB1D6B45997BE617DBBD16D48F5A3BAC32BFCC',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['files'] ?? [];
      } else {
        print("Drive Error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Drive Error: $e");
      return [];
    }
  }

  // 🔹 Load contents of any folder (when user opens a folder)
  static Future<List<dynamic>> fetchFolderItems(String folderId) async {
    try {
     final url = Uri.parse(
  "https://www.googleapis.com/drive/v3/files"
  "?q='$folderId'+in+parents"
  "&corpora=allDrives"
  "&supportsAllDrives=true"
  "&includeItemsFromAllDrives=true"
  "&fields=files(id,name,mimeType,size)"
  "&orderBy=folder,name"
  "&key=${DriveConfig.apiKey}",
);


      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['files'] ?? [];
      } else {
        print("Drive Folder Error: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Drive Folder Exception: $e");
      return [];
    }
  }
}
