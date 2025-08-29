import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class GamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    final apiData = await EsportsService.getUpcomingGames();
    return apiData.map((gameData) => Game.fromApi(gameData)).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiData = await EsportsService.getUpcomingGames();
      return apiData.map((gameData) => Game.fromApi(gameData)).toList();
    });
  }


}

final gamesProvider = AsyncNotifierProvider<GamesNotifier, List<Game>>(
  () => GamesNotifier(),
);

