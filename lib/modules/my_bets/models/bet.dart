import 'package:overwin_mobile/modules/my_bets/models/bet_selection.dart';

class Bet {
  final int id;
  final int userId;
  final double stake;
  final double totalOdd;
  final double potentialReturn;
  final String type; // "single" or "combine"
  final String status; // "pending", "won", "lost", "cancelled"
  final String placedAt;
  final List<BetSelection> selections;
  final double? winAmount;
  final String? result;
  final String? formattedDate;

  const Bet({
    required this.id,
    required this.userId,
    required this.stake,
    required this.totalOdd,
    required this.potentialReturn,
    required this.type,
    required this.status,
    required this.placedAt,
    required this.selections,
    this.winAmount,
    this.result,
    this.formattedDate,
  });

  factory Bet.fromJson(Map<String, dynamic> json) {
    return Bet(
      id: json['id'] as int,
      userId: json['userId'] as int,
      stake: (json['stake'] as num).toDouble(),
      totalOdd: (json['totalOdd'] as num).toDouble(),
      potentialReturn: (json['potentialReturn'] as num).toDouble(),
      type: json['type'] as String,
      status: json['status'] as String,
      placedAt: json['placedAt'] as String,
      selections: (json['selections'] as List<dynamic>)
          .map((e) => BetSelection.fromJson(e as Map<String, dynamic>))
          .toList(),
      winAmount: json['winAmount'] != null ? (json['winAmount'] as num).toDouble() : null,
      result: json['result'] as String?,
      formattedDate: json['formattedDate'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'stake': stake,
      'totalOdd': totalOdd,
      'potentialReturn': potentialReturn,
      'type': type,
      'status': status,
      'placedAt': placedAt,
      'selections': selections.map((e) => e.toJson()).toList(),
      'winAmount': winAmount,
      'result': result,
      'formattedDate': formattedDate,
    };
  }
}
