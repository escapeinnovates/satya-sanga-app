import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quote_model.dart';

class QuoteService {
  static const String _url =
      'https://opensheet.elk.sh/1k1e0ymzVUYeottVp29J-q37V1ulb6eJi29OgfcrNUvU/Sheet1';

  static Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode != 200) {
        print('❌ Sheet error: ${response.statusCode}');
        return [];
      }

      final List<dynamic> jsonList = json.decode(response.body);

      final quotes = jsonList
          .map((e) => QuoteModel.fromJson(e))
          .where((q) => q.quote.isNotEmpty)
          .toList();

      print('✅ Quotes loaded: ${quotes.length}');
      return quotes;
    } catch (e) {
      print('❌ Quote fetch error: $e');
      return [];
    }
  }
}
