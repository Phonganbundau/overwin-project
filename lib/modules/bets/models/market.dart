import 'selection.dart';

class Market {
  final int id;
  final int? competitionId;
  final int gameId;
  final String type;
  final String name;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Selection> selections;

  Market({
    required this.id,
    this.competitionId,
    required this.gameId,
    required this.type,
    required this.name,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.selections,
  });

  factory Market.fromJson(Map<String, dynamic> json) {
    return Market(
      id: json['id']?.toInt() ?? 0,
      competitionId: json['competitionId']?.toInt(),
      gameId: json['gameId']?.toInt() ?? 0,
      type: json['type']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'].toString())
          : DateTime.now(),
      selections: (json['selections'] as List<dynamic>?)
          ?.map((selection) => Selection.fromJson(selection))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'competitionId': competitionId,
      'gameId': gameId,
      'type': type,
      'name': name,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'selections': selections.map((selection) => selection.toJson()).toList(),
    };
  }
}
