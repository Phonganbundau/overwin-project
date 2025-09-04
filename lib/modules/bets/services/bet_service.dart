import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:overwin_mobile/shared/services/api_service.dart';
import 'package:overwin_mobile/shared/services/secure_storage_service.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';

class BetService {
  // Tạo phiếu cược mới
  static Future<Map<String, dynamic>> placeBet({
    required double stake,
    required double totalOdd,
    required List<SelectedOutcome> selections,
    required BuildContext context,
  }) async {
    try {
      // Kiểm tra xem có lựa chọn nào không
      if (selections.isEmpty) {
        return {
          'success': false,
          'message': 'Vui lòng chọn ít nhất một kèo cược',
          'newBalance': null
        };
      }

      // Kiểm tra stake có hợp lệ không
      if (stake <= 0) {
        return {
          'success': false,
          'message': 'Số tiền cược phải lớn hơn 0',
          'newBalance': null
        };
      }

      // Xác định loại cược (đơn hay kết hợp)
      String betType = selections.length > 1 ? 'combine' : 'single';

      // Chuẩn bị danh sách selections
      List<Map<String, dynamic>> selectionsList = selections.map((outcome) {
        return {
          'selectionId': outcome.outcomeId,
          'oddAtPlacement': outcome.outcomeOdd,
        };
      }).toList();

      // Tạo payload
      Map<String, dynamic> payload = {
        'stake': stake,
        'totalOdd': totalOdd,
        'type': betType,
        'selections': selectionsList,
      };

      // Gọi API
      final response = await ApiService.post('/bets/place-bet', payload);

      return {
        'success': response['success'],
        'message': response['message'],
        'newBalance': response['newBalance'],
        'betId': response['id'],
      };
    } catch (e) {
      // Xử lý lỗi không đủ token từ backend
      if (e.toString().contains('insufficient') || 
          e.toString().contains('balance') || 
          e.toString().contains('token')) {
        return {
          'success': false,
          'message': 'Tu n\'as pas assez de jeton sur ton compte pour placer ce paris.',
          'newBalance': null
        };
      }
      
      return {
        'success': false,
        'message': 'Erreur: ${e.toString()}',
        'newBalance': null
      };
    }
  }
}
