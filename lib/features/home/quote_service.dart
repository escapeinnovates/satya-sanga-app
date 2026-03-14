import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:satya_sang/core/security/hmac_helper.dart';
import 'quote_model.dart';
import 'package:satya_sang/core/config/api_config.dart';

class QuoteService {

  static Future<QuoteModel?> fetchTodayQuote() async {

    print("fetchTodayQuote called");

    try {

      final path = "/api/quotes";

      final response = await http.get(
        Uri.parse("${ApiConfig.baseUrl}$path"),
        headers: HmacHelper.buildHeaders(path),
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> decoded = json.decode(response.body);

      if (decoded['success'] != true || decoded['data'] == null) {
        return null;
      }

      final quoteData = decoded['data'];

      return QuoteModel.fromJson(quoteData);

    } catch (e, stack) {

      print("Quote fetch error: $e");
      print(stack);

      return null;
    }
  }
}