import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    try {
      final apiData = await EsportsService.getUpcomingGames();
      return apiData.map((gameData) => Game.fromApi(gameData)).toList();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockData();
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final apiData = await EsportsService.getUpcomingGames();
        return apiData.map((gameData) => Game.fromApi(gameData)).toList();
      } catch (e) {
        return _getMockData();
      }
    });
  }

  // Fallback mock data
  List<Game> _getMockData() {
    final List<Map<String, dynamic>> raw = [
      {
        "game_id": 1,
        "name": "1er Tour Ronde Suisse",
        "image_path": "https://pbs.twimg.com/media/GylYhG7WMAEuHkf?format=jpg&name=900x900",
        "scheduled_at": "2025-09-11 17:30:00",
        "competition_name": "RLCS 2025",
        "competition_icon": "assets/icons/rlcs.png",
        "esport_icon": "assets/icons/rocket-league-logo.png",
        "opponents": [
          {"name": "Gentle Mates", "logo": "assets/icons/m8-logo.png"},
          {"name": "Karmine Corp", "logo": "assets/icons/kc-logo.png"}
        ],
        "bet_outcomes": [
          {"id": 1, "name": "Gentle Mates", "odd_value": 17.44, "status": null, "bet_type_name": "Vainqueur du match"},
          {"id": 2, "name": "Karmine Corp", "odd_value": 2.80, "status": null, "bet_type_name": "Vainqueur du match"}
        ]
      },
      {
        "game_id": 2,
        "name": "1er Tour Ronde Suisse",
        "image_path": null,
        "scheduled_at": "2025-09-11 19:30:00",
        "competition_name": "RLCS 2025",
        "competition_icon": "assets/icons/rlcs.png",
        "esport_icon": "assets/icons/rocket-league-logo.png",
        "opponents": [
          {"name": "Vitality", "logo": "assets/icons/m8-logo.png"},
          {"name": "BDS", "logo": "assets/icons/kc-logo.png"}
        ],
        "bet_outcomes": [
          {"id": 3, "name": "Vitality", "odd_value": 1.94, "status": null, "bet_type_name": "Vainqueur du match"},
          {"id": 4, "name": "BDS", "odd_value": 2.05, "status": null, "bet_type_name": "Vainqueur du match"}
        ]
      },
    ];

    return raw.map((e) => Game.fromJson(e)).toList();
  }
}

final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  () => GamesNotifier(),
);
