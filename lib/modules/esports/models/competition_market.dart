import 'package:overwin_mobile/modules/bets/models/selection.dart';

/// Mô hình dữ liệu cho kèo ở cấp độ giải đấu (competition-level)
class CompetitionMarket {
  final int id;
  final int competitionId;
  final String competitionName;
  final String competitionIcon;
  final String type;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Selection> selections;

  const CompetitionMarket({
    required this.id,
    required this.competitionId,
    required this.competitionName,
    required this.competitionIcon,
    required this.type,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.selections,
  });

  factory CompetitionMarket.fromJson(Map<String, dynamic> json) {
    return CompetitionMarket(
      id: json['id'] as int,
      competitionId: json['competitionId'] as int,
      competitionName: json['competitionName'] as String,
      competitionIcon: json['competitionIcon'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      selections: (json['selections'] as List<dynamic>)
          .map((e) => Selection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competitionId': competitionId,
      'competitionName': competitionName,
      'competitionIcon': competitionIcon,
      'type': type,
      'name': name,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'selections': selections.map((e) => e.toJson()).toList(),
    };
  }
}
