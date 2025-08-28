class BetSelection {
  final int id;
  final int betId;
  final int selectionId;
  final double oddAtPlacement;
  final String status;
  final String selectionName;
  final String? selectionCode;
  final String? marketType;
  final String? marketName;
  final int? gameId;
  final String? gameName;
  final String? gameScore;
  final String? team;
  final String? opponent;
  final String? opponent1Name;
  final String? opponent2Name;
  final String? competitionName;
  final String? sportName;
  final String? sportIcon;
  final String? date;

  const BetSelection({
    required this.id,
    required this.betId,
    required this.selectionId,
    required this.oddAtPlacement,
    required this.status,
    required this.selectionName,
    this.selectionCode,
    this.marketType,
    this.marketName,
    this.gameId,
    this.gameName,
    this.gameScore,
    this.team,
    this.opponent,
    this.opponent1Name,
    this.opponent2Name,
    this.competitionName,
    this.sportName,
    this.sportIcon,
    this.date,
  });

  factory BetSelection.fromJson(Map<String, dynamic> json) {
    return BetSelection(
      id: json['id'] as int,
      betId: json['betId'] as int,
      selectionId: json['selectionId'] as int,
      oddAtPlacement: (json['oddAtPlacement'] as num).toDouble(),
      status: json['status'] as String,
      selectionName: json['selectionName'] as String,
      selectionCode: json['selectionCode'] as String?,
      marketType: json['marketType'] as String?,
      marketName: json['marketName'] as String?,
      gameId: json['gameId'] as int?,
      gameName: json['gameName'] as String?,
      gameScore: json['gameScore'] as String?,
      team: json['team'] as String?,
      opponent: json['opponent'] as String?,
      opponent1Name: json['opponent1Name'] as String?,
      opponent2Name: json['opponent2Name'] as String?,
      competitionName: json['competitionName'] as String?,
      sportName: json['sportName'] as String?,
      sportIcon: json['sportIcon'] as String?,
      date: json['date'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'betId': betId,
      'selectionId': selectionId,
      'oddAtPlacement': oddAtPlacement,
      'status': status,
      'selectionName': selectionName,
      'selectionCode': selectionCode,
      'marketType': marketType,
      'marketName': marketName,
      'gameId': gameId,
      'gameName': gameName,
      'gameScore': gameScore,
      'team': team,
      'opponent': opponent,
      'opponent1Name': opponent1Name,
      'opponent2Name': opponent2Name,
      'competitionName': competitionName,
      'sportName': sportName,
      'sportIcon': sportIcon,
      'date': date,
    };
  }
}
