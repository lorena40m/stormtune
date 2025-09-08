import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stormtune/models/tuning_recommendation.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000'; // Change for production
  
  static Future<TuningRecommendation> getRecommendations({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/recommend'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TuningRecommendation.fromJson(data);
      } else {
        throw Exception('Failed to get recommendations: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
} 