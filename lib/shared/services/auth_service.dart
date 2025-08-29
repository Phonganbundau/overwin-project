import 'package:overwin_mobile/shared/services/api_service.dart';

class AuthService {
  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final data = {
      'email': email,
      'password': password,
    };
    
    try {
      final response = await ApiService.post('/auth/login', data);
      return response;
    } catch (e) {
      // Log error để debug
      print('Login Error in AuthService: $e');
      rethrow;
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String email,
    required String firstName,
    required String lastName,
    required String username,
    required DateTime dateOfBirth,
    required String phoneNumber,
    required String password,
  }) async {
    final data = {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'username': username,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'phoneNumber': phoneNumber,
      'password': password,
    };
    
    final response = await ApiService.post('/auth/register', data);
    return response;
  }

  // Get user profile
  static Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await ApiService.get('/auth/profile', token: token);
    return response;
  }
  
  // Get user profile without token (uses stored token)
  static Future<Map<String, dynamic>> getProfileFromStorage() async {
    final response = await ApiService.get('/auth/profile');
    return response;
  }
  
  // Verify email with code
  static Future<Map<String, dynamic>> verifyEmailWithCode({
    required String email,
    required String code,
  }) async {
    final data = {
      'email': email,
      'code': code,
    };
    
    final response = await ApiService.post('/auth/verify-email', data);
    return response;
  }
}
