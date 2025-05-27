import 'dart:convert';
import 'package:http/http.dart' as http;

class BaseNetwork {
  static const String baseUrl = 'https://681388b3129f6313e2119693.mockapi.io/api/v1/';

  static Future<List<dynamic>> getData(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data is List) {
        return data;
      } else {
        throw Exception('Invalid data format received from API for $endpoint');
      }
    } else {
      throw Exception('Failed to load data from $endpoint. Status code: ${response.statusCode}');
    }
  }

  static Future<Map<String, dynamic>> getDetailData(String endpoint, String id) async {
    final response = await http.get(Uri.parse('$baseUrl$endpoint/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load detail data for $id. Status code: ${response.statusCode}');
    }
  }
}