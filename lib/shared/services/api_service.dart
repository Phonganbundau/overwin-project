import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overwin_mobile/shared/services/secure_storage_service.dart';

class ApiService {
  static const String baseUrl ='http://192.168.1.132:8080/api';
  
  // Headers
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
  };
  
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await SecureStorageService.getToken();
    if (token != null) {
      return {
        ..._defaultHeaders,
        'Authorization': 'Bearer $token',
      };
    }
    return _defaultHeaders;
  }
  
  static Map<String, String> getAuthHeadersWithToken(String token) => {
    ..._defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  // Generic GET request
  static Future<dynamic> get(String endpoint, {String? token}) async {
    try {
      final headers = token != null 
          ? getAuthHeadersWithToken(token) 
          : await getAuthHeaders();
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Generic POST request
  static Future<dynamic> post(String endpoint, Map<String, dynamic> data, {String? token}) async {
    try {
      final headers = token != null 
          ? getAuthHeadersWithToken(token) 
          : await getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(data),
      );
      
      // Parse response body
      final responseBody = json.decode(response.body);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        return responseBody;
      } else {
        // Check if response contains error message
        final errorMessage = responseBody['message'] ?? 'Failed to post data: ${response.statusCode}';
        throw Exception(errorMessage);
      }
    } catch (e) {
      if (e is Exception) {
        rethrow; // Re-throw if it's already an Exception
      } else {
        throw Exception('Network error: $e');
      }
    }
  }
}
