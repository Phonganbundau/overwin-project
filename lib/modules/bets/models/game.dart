import 'opponent.dart';

class Game {
  final int id;
  final String name;
  final String imageUrl;
  final DateTime scheduledAt;
  final bool isEnded;
  final int competitionId;
  final String competitionName;
  final String competitionIcon;
  final int esportId;
  final String esportName;
  final String esportIcon;
  final int? opponent1Id;
  final int? opponent2Id;
  final int? opponent1Score;
  final int? opponent2Score;
  final List<Opponent> opponents;
  final List<dynamic> markets; // Updated to markets instead of outcomes

  Game({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.scheduledAt,
    required this.isEnded,
    required this.competitionId,
    required this.competitionName,
    required this.competitionIcon,
    required this.esportId,
    required this.esportName,
    required this.esportIcon,
    this.opponent1Id,
    this.opponent2Id,
    this.opponent1Score,
    this.opponent2Score,
    required this.opponents,
    required this.markets,
  });

  // Get all selections from all markets with null safety
  List<Map<String, dynamic>> getSelections() {
    List<Map<String, dynamic>> selections = [];
    
    try {
      for (var market in markets) {
        if (market != null && market is Map<String, dynamic>) {
          var selectionsList = market['selections'];
          if (selectionsList != null && selectionsList is List) {
            for (var selection in selectionsList) {
              if (selection != null && selection is Map<String, dynamic>) {
                var id = selection['id'];
                var name = selection['name'];
                var odd = selection['odd'];
                var marketName = market['name'];
                var marketId = market['id'];
                var marketType = market['type'];
                
                // Only add if all required fields are present
                if (id != null && name != null && odd != null && marketName != null) {
                  selections.add({
                    'id': id,
                    'name': name.toString(),
                    'oddValue': odd is num ? odd.toDouble() : 1.0,
                    'betTypeName': marketName.toString(),
                    'marketId': marketId,
                    'marketType': marketType?.toString() ?? '',
                  });
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error parsing selections from markets: $e');
    }
    
    return selections;
  }

  factory Game.fromJson(Map<String, dynamic> json) {
    try {
      return Game(
        id: json['id']?.toInt() ?? 0,
        name: json['name']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString() ?? '',
        scheduledAt: json['scheduledAt'] != null 
            ? DateTime.parse(json['scheduledAt'].toString())
            : DateTime.now(),
        isEnded: json['isEnded'] == true,
        competitionId: json['competitionId']?.toInt() ?? 0,
        competitionName: json['competitionName']?.toString() ?? 'Competition',
        competitionIcon: json['competitionIcon']?.toString() ?? 'assets/icons/rlcs.png',
        esportId: json['esportId']?.toInt() ?? 1,
        esportName: json['esportName']?.toString() ?? 'Rocket League',
        esportIcon: json['esportIcon']?.toString() ?? 'assets/icons/rocket-league-logo.png',
        opponent1Id: json['opponent1Id']?.toInt(),
        opponent2Id: json['opponent2Id']?.toInt(),
        opponent1Score: json['opponent1Score']?.toInt(),
        opponent2Score: json['opponent2Score']?.toInt(),
        opponents: _parseOpponents(json['opponents']),
        markets: json['markets'] ?? [],
      );
    } catch (e) {
      print('Error parsing Game from JSON: $e');
      // Return a default game if parsing fails
      return Game(
        id: 0,
        name: 'Error loading game',
        imageUrl: '',
        scheduledAt: DateTime.now(),
        isEnded: false,
        competitionId: 0,
        competitionName: 'Competition',
        competitionIcon: 'assets/icons/rlcs.png',
        esportId: 1,
        esportName: 'Rocket League',
        esportIcon: 'assets/icons/rocket-league-logo.png',
        opponents: [
          Opponent(id: 1, name: 'Team 1', logo: 'assets/icons/kc-logo.png'),
          Opponent(id: 2, name: 'Team 2', logo: 'assets/icons/m8-logo.png'),
        ],
        markets: [],
      );
    }
  }

  // Helper method to parse opponents safely
  static List<Opponent> _parseOpponents(dynamic opponentsData) {
    try {
      if (opponentsData is List) {
        return opponentsData
            .where((o) => o != null)
            .map((o) => Opponent.fromJson(o))
            .toList();
      }
    } catch (e) {
      print('Error parsing opponents: $e');
    }
    
    // Return default opponents if parsing fails
    return [
      Opponent(id: 1, name: 'Team 1', logo: 'assets/icons/kc-logo.png'),
      Opponent(id: 2, name: 'Team 2', logo: 'assets/icons/m8-logo.png'),
    ];
  }

  // Convert from API response
  factory Game.fromApi(Map<String, dynamic> data) {
    try {
      return Game(
        id: data['id']?.toInt() ?? 0,
        name: data['name']?.toString() ?? '',
        imageUrl: data['imageUrl']?.toString() ?? '',
        scheduledAt: data['scheduledAt'] != null 
            ? DateTime.parse(data['scheduledAt'].toString())
            : DateTime.now(),
        isEnded: data['isEnded'] == true,
        competitionId: data['competitionId']?.toInt() ?? 0,
        competitionName: data['competitionName']?.toString() ?? 'Competition',
        competitionIcon: data['competitionIcon']?.toString() ?? 'assets/icons/rlcs.png',
        esportId: data['esportId']?.toInt() ?? 0,
        esportName: data['esportName']?.toString() ?? 'Rocket League',
        esportIcon: data['esportIcon']?.toString() ?? 'assets/icons/rocket-league-logo.png',
        opponent1Id: data['opponent1Id']?.toInt() ?? 0,
        opponent2Id: data['opponent2Id']?.toInt() ?? 0,
        opponent1Score: data['opponent1Score']?.toInt() ?? 0,
        opponent2Score: data['opponent2Score']?.toInt() ?? 0,
        opponents: _parseOpponents(data['opponents']),
        markets: data['markets'] ?? [],
      );
    } catch (e) {
      print('Error parsing Game from API: $e');
      // Return a default game if parsing fails
      return Game(
        id: 0,
        name: 'Error loading game',
        imageUrl: '',
        scheduledAt: DateTime.now(),
        isEnded: false,
        competitionId: 0,
        competitionName: 'Competition',
        competitionIcon: 'assets/icons/rlcs.png',
        esportId: 0,
        esportName: 'Rocket League',
        esportIcon: 'assets/icons/rocket-league-logo.png',
        opponents: [
          Opponent(id: 1, name: 'Team 1', logo: 'assets/icons/kc-logo.png'),
          Opponent(id: 2, name: 'Team 2', logo: 'assets/icons/m8-logo.png'),
        ],
        markets: [],
      );
    }
  }
}