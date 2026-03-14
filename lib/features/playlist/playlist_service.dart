import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'package:satya_sang/core/config/api_config.dart';

class PlaylistService {
  Future<List<dynamic>> fetchPlaylists() async {

    const path = "/api/youtube/playlists";
    print(path);
    final url = Uri.parse("${ApiConfig.baseUrl}$path");
    print(url);

    final response = await http.get(
      url,
      headers: HmacHelper.buildHeaders(path),
    );
    print(response);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return List<dynamic>.from(data['items'] ?? []);
    }

    return [];
  }
}
