import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    try {
      final apiData = await EsportsService.getUpcomingGames();
      if (apiData.isNotEmpty) {
        return apiData.map((gameData) => Game.fromApi(gameData)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final apiData = await EsportsService.getUpcomingGames();
      if (apiData.isNotEmpty) {
        state = AsyncValue.data(apiData.map((gameData) => Game.fromApi(gameData)).toList());
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e) {
      state = const AsyncValue.data([]);
    }
  }


}

final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  () => GamesNotifier(),
);

