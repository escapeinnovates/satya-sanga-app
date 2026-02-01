import 'dart:convert';
import 'package:http/http.dart' as http;
import 'quote_model.dart';

class QuoteService {
  // 🔁 Choose correct baseUrl

  // Flutter Linux / Windows / macOS
  static const String baseUrl = "http://localhost:4000";

  // Android Emulator
  // static const String baseUrl = "http://10.0.2.2:4000";

  // Real device
  // static const String baseUrl = "http://<YOUR_LOCAL_IP>:4000";

  static Future<List<QuoteModel>> fetchQuotes() async {
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/api/sheets/quotes"));

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
