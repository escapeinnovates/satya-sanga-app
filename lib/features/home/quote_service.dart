import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'quote_model.dart';
import 'package:satya_sang/core/config/api_config.dart';


class QuoteService {

  static Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final path = "/api/sheets/quotes";

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}$path"),
        headers: HmacHelper.buildHeaders(path),
      );

      if (response.statusCode != 200) {
        print("❌ Backend quote error: ${response.statusCode}");
        return [];
      }

      final data = json.decode(response.body);
      final List<dynamic> list = data['items'] ?? [];

      final quotes = list
          .map((e) => QuoteModel.fromJson(e))
          .where((q) => q.day.trim().isNotEmpty)
          .toList();

      return quotes;
    } catch (e) {
      print("❌ QuoteService error: $e");
      return [];
    }
  }
}
