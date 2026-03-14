import 'dart:convert';
import 'package:http/http.dart' as http;

import 'quick_access_model.dart';
import '../../core/security/hmac_helper.dart';
import '../../core/config/api_config.dart';

class QuickAccessService {

  static Future<List<QuickAccessModel>> fetchQuickAccess() async {

    print("fetchQuickAccess called");

    try {

      final path = "/api/quick-sections";
      final url = "${ApiConfig.baseUrl}$path";

      final response = await http.get(
        Uri.parse(url),
        headers: HmacHelper.buildHeaders(path),
      );

      print("QuickAccess Status: ${response.statusCode}");
      print("QuickAccess Body: ${response.body}");

      if (response.statusCode != 200) {
        return [];
      }

      final decoded = json.decode(response.body);

      // 🔹 FIX: extract list from "data"
      if (decoded['data'] == null) {
        return [];
      }

      final List<dynamic> list = decoded['data'];

      return list
          .map((item) => QuickAccessModel.fromJson(item))
          .toList();

    } catch (e, stack) {

      print("Quick access error: $e");
      print(stack);

      return [];
    }
  }
}