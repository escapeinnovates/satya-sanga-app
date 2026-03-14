import 'dart:convert';
import 'package:crypto/crypto.dart';

class HmacHelper {
  static const String _secret = "satyasang_super_secret_2026";

  static Map<String, String> buildHeaders(
    String path, {
    String method = "GET",
  }) {
    final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
        .toString();

    final payload = "$method\n$path\n$timestamp";

    final hmac = Hmac(sha256, utf8.encode(_secret));

    final signature = hmac.convert(utf8.encode(payload)).toString();

    return {
      "x-timestamp": timestamp,
      "x-signature": signature,
      "accept": "application/json",
    };
  }
}
