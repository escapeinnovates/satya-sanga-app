import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import '../config/drive_config.dart'; // Ensure path is correct

class DriveService {
  
  static Future<List<dynamic>> fetchAudios() async {
    try {
      // 1. Get app identity info
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      
      // 2. Build the Drive Query URL
      // mimeType contains 'audio/' catches mp3, wav, m4a, etc.
      final url = Uri.parse(
        "https://www.googleapis.com/drive/v3/files"
        "?q='${DriveConfig.folderId}'+in+parents+and+mimeType+contains+'audio/'"
        "&fields=files(id,name,mimeType,size,webViewLink)"
        "&key=${DriveConfig.apiKey}",
      );

      // 3. Build Platform-Specific Headers (Same as YouTube)
      Map<String, String> headers = {
        'Accept': 'application/json',
      };

      if (Platform.isAndroid) {
        headers['X-Android-Package'] = packageInfo.packageName;
        // REMEMBER: No colons in the code, but colons in the Google Console
        headers['X-Android-Cert'] = 'C2CB1D6B45997BE617DBBD16D48F5A3BAC32BFCC'; 
      } else if (Platform.isIOS) {
        headers['X-Ios-Bundle-Identifier'] = packageInfo.packageName;
      }

      print('DriveService: Fetching from folder ${DriveConfig.folderId}');
      
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> files = data['files'] ?? [];
        print('DriveService: Successfully found ${files.length} audio files.');
        return files;
      } else {
        print('Drive API Error ${response.statusCode}: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Drive Service Critical Error: $e');
      return [];
    }
  }
}
