import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stormtune/models/tuning_recommendation.dart';

class ApiService {
  static const String baseUrl = 'http://95.217.41.161:8000'; // Production backend URL
  
  static Future<TuningRecommendation> getRecommendations({
    required Map<String, dynamic> payload,
  }) async {
    try {
      print('Sending request to: $baseUrl/api/recommend');
      print('Payload: ${jsonEncode(payload)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/api/recommend'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - please check your connection');
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return TuningRecommendation.fromJson(data);
      } else {
        String errorMessage = 'Failed to get recommendations';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['detail'] ?? errorMessage;
        } catch (e) {
          errorMessage = 'Server error (${response.statusCode})';
        }
        throw Exception(errorMessage);
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      if (e.toString().contains('timeout')) {
        throw Exception('Request timeout - please check your connection');
      }
      throw Exception('Error: ${e.toString()}');
    }
  }

  static Future<bool> checkApiHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/'),
      ).timeout(const Duration(seconds: 10));
      
      return response.statusCode == 200;
    } catch (e) {
      print('API health check failed: $e');
      return false;
    }
  }
}
