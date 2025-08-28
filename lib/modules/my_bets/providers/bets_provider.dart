import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:overwin_mobile/modules/my_bets/models/bet.dart';
import 'package:overwin_mobile/shared/services/api_service.dart';
import 'package:overwin_mobile/shared/services/secure_storage_service.dart';

// Provider để lấy tất cả bets (không còn cần thiết)
final allBetsProvider = FutureProvider<List<Bet>>((ref) async {
  try {
    final response = await _fetchBetsWithDebug('/bets/my-bets');
    return response;
  } catch (e) {
    debugPrint("Error in allBetsProvider: $e");
    rethrow;
  }
});

// Provider để lấy các bet đang diễn ra với khả năng refresh
final ongoingBetsProvider = FutureProvider.autoDispose<List<Bet>>((ref) async {
  try {
    debugPrint("=== Ongoing Bets Provider ===");
    final ongoingBets = await _fetchBetsWithDebug('/bets/my-ongoing-bets');
    debugPrint("Ongoing bets received: ${ongoingBets.length}");
    return ongoingBets;
  } catch (e) {
    debugPrint("Error in ongoingBetsProvider: $e");
    rethrow;
  }
});

// Provider để lấy các bet đã kết thúc với khả năng refresh
final finishedBetsProvider = FutureProvider.autoDispose<List<Bet>>((ref) async {
  try {
    debugPrint("=== Finished Bets Provider ===");
    final finishedBets = await _fetchBetsWithDebug('/bets/my-finished-bets');
    debugPrint("Finished bets received: ${finishedBets.length}");
    return finishedBets;
  } catch (e) {
    debugPrint("Error in finishedBetsProvider: $e");
    rethrow;
  }
});

// Provider để lấy các bet đã thắng với khả năng refresh
final wonBetsProvider = FutureProvider.autoDispose<List<Bet>>((ref) async {
  try {
    debugPrint("=== Won Bets Provider ===");
    final wonBets = await _fetchBetsWithDebug('/bets/my-won-bets');
    debugPrint("Won bets received: ${wonBets.length}");
    return wonBets;
  } catch (e) {
    debugPrint("Error in wonBetsProvider: $e");
    rethrow;
  }
});

// Provider để refresh tất cả bets
final refreshBetsProvider = StateNotifierProvider<RefreshBetsNotifier, void>((ref) {
  return RefreshBetsNotifier(ref);
});

// Notifier để refresh các provider
class RefreshBetsNotifier extends StateNotifier<void> {
  final Ref _ref;
  
  RefreshBetsNotifier(this._ref) : super(null);
  
  void refreshAllBets() {
    debugPrint("=== Refreshing all bets ===");
    // Invalidate tất cả các provider để force refresh
    _ref.invalidate(ongoingBetsProvider);
    _ref.invalidate(finishedBetsProvider);
    _ref.invalidate(wonBetsProvider);
    _ref.invalidate(allBetsProvider);
  }
  
  void refreshOngoingBets() {
    debugPrint("=== Refreshing ongoing bets ===");
    _ref.invalidate(ongoingBetsProvider);
  }
  
  void refreshFinishedBets() {
    debugPrint("=== Refreshing finished bets ===");
    _ref.invalidate(finishedBetsProvider);
  }
  
  void refreshWonBets() {
    debugPrint("=== Refreshing won bets ===");
    _ref.invalidate(wonBetsProvider);
  }
}

// Hàm helper để gọi API với debug
Future<List<Bet>> _fetchBetsWithDebug(String endpoint) async {
  try {
    // Kiểm tra token trước
    final token = await SecureStorageService.getToken();
    debugPrint("Token available: ${token != null}");
    
    if (token == null) {
      debugPrint("No token found, using demo token");
      // Tạm thời hardcode token để test - BẠN CẦN THAY ĐỔI
      const demoToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZXN0QGV4YW1wbGUuY29tIiwiaWF0IjoxNzI0NjY3Mjk2LCJleHAiOjE3MjQ3NTM2OTZ9.example";
      await SecureStorageService.saveToken(demoToken);
    }
    
    final headers = await ApiService.getAuthHeaders();
    debugPrint("Calling API: ${ApiService.baseUrl}$endpoint");
    debugPrint("Headers: $headers");
    
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}$endpoint'),
      headers: headers,
    );

    debugPrint("Response status: ${response.statusCode}");
    
    if (response.statusCode == 200) {
      final responseBody = response.body;
      debugPrint("Response body: $responseBody");
      
      final List<dynamic> data = json.decode(responseBody);
      debugPrint("Data length: ${data.length}");
      
      // Debug từng bet
      for (var i = 0; i < data.length; i++) {
        debugPrint("Bet $i: status=${data[i]['status']}, type=${data[i]['type']}");
      }
      
      final bets = data.map((json) => Bet.fromJson(json)).toList();
      debugPrint("Parsed bets: ${bets.length}");
      
      // Debug các bet đã parse
      for (var bet in bets) {
        debugPrint("Parsed Bet ID=${bet.id}: status=${bet.status}, type=${bet.type}");
      }
      
      return bets;
    } else {
      debugPrint("API call failed with status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");
      throw Exception('Failed to load bets: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint("Error in _fetchBetsWithDebug: $e");
    rethrow;
  }
}

// Hàm helper để lấy tất cả bet từ server (cho debug)
Future<List<Bet>> getAllBetsForDebug() async {
  return await _fetchBetsWithDebug('/bets/my-bets');
}

// Original helper function (kept for compatibility)
Future<List<Bet>> _fetchBets(String endpoint) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiService.baseUrl}$endpoint'),
      headers: await ApiService.getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Bet.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load bets: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error fetching bets: $e');
  }
}