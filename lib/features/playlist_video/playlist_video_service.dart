import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/youtube_config.dart';
import 'package:package_info_plus/package_info_plus.dart';

class YouTubeService {


Future<List<dynamic>> fetchPlaylistVideos(String playlistId) async {
  final packageInfo = await PackageInfo.fromPlatform();

  final url =
      'https://www.googleapis.com/youtube/v3/playlistItems'
      '?part=snippet'
      '&maxResults=50'
      '&playlistId=$playlistId'
      '&key=${YouTubeConfig.apiKey}';

  final headers = <String, String>{
    'Accept': 'application/json',
  };

  if (Platform.isAndroid) {
    headers['X-Android-Package'] = packageInfo.packageName;
    headers['X-Android-Cert'] = 'C2CB1D6B45997BE617DBBD16D48F5A3BAC32BFCC';
  } else if (Platform.isIOS) {
    headers['X-Ios-Bundle-Identifier'] = packageInfo.packageName;
  }

  final response = await http.get(Uri.parse(url), headers: headers);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return List<dynamic>.from(data['items'] ?? []);
  } else {
    throw Exception('Failed to load playlist videos');
  }
}
}
