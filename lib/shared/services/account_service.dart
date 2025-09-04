import 'package:overwin_mobile/shared/services/api_service.dart';

class AccountService {
  // Delete user account
  static Future<Map<String, dynamic>> deleteAccount() async {
    try {
      final response = await ApiService.delete('/auth/delete-account');
      return response;
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}
