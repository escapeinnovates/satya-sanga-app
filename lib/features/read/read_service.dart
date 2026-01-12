import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../../../config/drive_config.dart';

class ReadService {
  static Future<List<dynamic>> fetchPDFs() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      final url = Uri.parse(
        "https://www.googleapis.com/drive/v3/files"
        "?q='${DriveConfig.folderId}'+in+parents+and+mimeType='application/pdf'"
        "&fields=files(id,name,webViewLink,thumbnailLink)"
        "&key=${DriveConfig.apiKey}",
      );

      Map<String, String> headers = {'Accept': 'application/json'};
      if (Platform.isAndroid) {
        headers['X-Android-Package'] = packageInfo.packageName;
        headers['X-Android-Cert'] = 'C2CB1D6B45997BE617DBBD16D48F5A3BAC32BFCC';
      } else if (Platform.isIOS) {
        headers['X-Ios-Bundle-Identifier'] = packageInfo.packageName;
      }

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> files = data['files'] ?? [];
        return files;
      } else {
        print('Drive API Error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('ReadService Error: $e');
      return [];
    }
  }
}
