import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/youtube_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class YouTubeService {
  Future<List<dynamic>> fetchShorts() async {
    print('1: Starting fetchShorts');
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    print('2: Package Name is: ${YouTubeConfig.apiKey}');
    final url =
        'https://www.googleapis.com/youtube/v3/search'
        '?part=snippet'
        '&channelId=${YouTubeConfig.channelId}'
        '&maxResults=25'
        '&type=video'
        '&videoDuration=short'
        '&key=${YouTubeConfig.apiKey}';

    // Build platform-specific headers
    Map<String, String> headers = {'Accept': 'application/json'};

    if (Platform.isAndroid) {
      headers['X-Android-Package'] =
          packageInfo.packageName; // Must match Console
      headers['X-Android-Cert'] =
          'C2CB1D6B45997BE617DBBD16D48F5A3BAC32BFCC'; // No colons
    } else if (Platform.isIOS) {
      headers['X-Ios-Bundle-Identifier'] =
          packageInfo.packageName; // Must match Console
    }

    print(url);
    print(headers);
    final response = await http.get(Uri.parse(url), headers: headers);
    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['items'] ?? [];
    } else {
      print('Error ${response.statusCode}: ${response.body}');
      return [];
    }
  }
}
