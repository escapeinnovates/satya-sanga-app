import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_keys.dart';

class ChannelPlaylistService {
  Future<List> fetchPlaylists(String channelId) async {
    final url =
        "https://www.googleapis.com/youtube/v3/playlists?part=snippet,contentDetails&maxResults=50&channelId=UCogtnchGlab9CSmWLnhVvtA&key=AIzaSyCKHsjQr3DUf0jxox7uUUeU6MSTRJ5X_M8";

    final res = await http.get(Uri.parse(url));
    final data = json.decode(res.body);
    return data['items'];
  }
}
