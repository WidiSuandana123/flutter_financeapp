import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_financeapp/dto/news.dart';
import 'package:flutter_financeapp/endpoints/endpoints.dart';

class DataService {
  static Future<List<News>> fetchNews() async {
    final response = await http.get(Uri.parse(Endpoints.news));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((item) => News.fromJson(item)).toList();
    } else {
      // Handle error
      throw Exception('Failed to load news');
    }
  }

  static void updateData(String id, String title, String body) {}

  static void deleteData(String id) {}

  static void sendNews(String text, String text2) {}
}
