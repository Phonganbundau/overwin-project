import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/shared/services/auth_service.dart';
import 'package:overwin_mobile/shared/services/secure_storage_service.dart';
import 'package:overwin_mobile/shared/services/api_service.dart';

class EmailNotVerifiedException implements Exception {
  final String email;
  EmailNotVerifiedException(this.email);
  
  @override
  String toString() => 'Email not verified: $email';
}

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final DateTime dateOfBirth;
  final String phoneNumber;
  final double balance;
  final String? token;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.username,
    required this.dateOfBirth,
    required this.phoneNumber,
    required this.balance,
    this.token,
  });

  // Convert from API response
  factory User.fromApi(Map<String, dynamic> data, {String? token}) {
    // Handle balance type conversion safely
    double balance;
    if (data['balance'] != null) {
      if (data['balance'] is double) {
        balance = data['balance'] as double;
      } else if (data['balance'] is int) {
        balance = (data['balance'] as int).toDouble();
      } else {
        balance = double.tryParse(data['balance'].toString()) ?? 0.0;
      }
    } else {
      balance = 0.0;
    }
    
    return User(
      id: data['id'].toString(),
      email: data['email'],
      firstName: data['firstName'],
      lastName: data['lastName'],
      username: data['username'] ?? '',
      dateOfBirth: DateTime.parse(data['dateOfBirth']),
      phoneNumber: data['phoneNumber'],
      balance: balance,
      token: token,
    );
  }
}

class AuthNotifier extends StateNotifier<User?> {
  AuthNotifier() : super(null);

  Future<void> signIn(String email, String password) async {
    try {
      final response = await AuthService.login(email, password);
      
      if (response['token'] != null && response['user'] != null) {
        final user = User.fromApi(response['user'], token: response['token']);
        
        // Save authentication data to secure storage
        await SecureStorageService.saveAuthData(
          token: response['token'],
          userId: user.id,
          email: user.email,
        );
        
        state = user;
      } else {
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {
      // Log error để debug
      print('SignIn Error in AuthNotifier: $e');
      
      // Kiểm tra nếu là EmailVerificationException từ API
      if (e is EmailVerificationException) {
        throw EmailNotVerifiedException(e.data['email'] ?? email);
      }
      
      throw Exception('Login failed: $e');
    }
  }

  Future<void> signUp({
    required String email,
    required String firstName,
    required String lastName,
    required String username,
    required DateTime dateOfBirth,
    required String phoneNumber,
    required String password,
  }) async {
    try {
      await AuthService.register(
        email: email,
        firstName: firstName,
        lastName: lastName,
        username: username,
        dateOfBirth: dateOfBirth,
        phoneNumber: phoneNumber,
        password: password,
      );
      
      // Registration successful - don't auto sign in since email needs verification
      // User will need to verify email first, then sign in manually
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }
  
  Future<Map<String, dynamic>> verifyEmailWithCode({
    required String email,
    required String code,
  }) async {
    try {
      return await AuthService.verifyEmailWithCode(email: email, code: code);
    } catch (e) {
      throw Exception('Email verification failed: $e');
    }
  }

  Future<void> signOut() async {
    // Clear authentication data from secure storage
    await SecureStorageService.clearAuthData();
    state = null;
  }

  bool get isLoggedIn => state != null;
  
  String? get token => state?.token;
  
  double get tokens => state?.balance ?? 0.0;
  
  // Restore authentication state from secure storage
  Future<void> restoreAuthState() async {
    try {
      final token = await SecureStorageService.getToken();
      final userId = await SecureStorageService.getUserId();
      final email = await SecureStorageService.getUserEmail();
      
      if (token != null && userId != null && email != null) {
        // Try to get user profile from API using stored token
        final userProfile = await AuthService.getProfile(token);
        if (userProfile != null) {
          final user = User.fromApi(userProfile, token: token);
          state = user;
        }
      }
    } catch (e) {
      print('Error restoring auth state: $e');
      // If restoration fails, clear stored data
      await SecureStorageService.clearAuthData();
    }
  }

  // Update user balance after successful bet
  void updateBalance(double newBalance) {
    if (state != null) {
      final updatedUser = User(
        id: state!.id,
        email: state!.email,
        firstName: state!.firstName,
        lastName: state!.lastName,
        username: state!.username,
        dateOfBirth: state!.dateOfBirth,
        phoneNumber: state!.phoneNumber,
        balance: newBalance,
        token: state!.token,
      );
      state = updatedUser;
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, User?>((ref) {
  return AuthNotifier();
});

final isLoggedInProvider = Provider<bool>((ref) {
  final user = ref.watch(authProvider);
  return user != null;
});

final tokenProvider = Provider<String?>((ref) {
  final user = ref.watch(authProvider);
  return user?.token;
});
