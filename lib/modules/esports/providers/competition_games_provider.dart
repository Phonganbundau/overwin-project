import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class CompetitionGamesNotifier extends AsyncNotifier<List<Game>> {
  @override
  Future<List<Game>> build() async {
    // This will be overridden by the family provider
    return [];
  }
  
  Future<List<Game>> getGamesForCompetition(int competitionId) async {
    try {
      final apiData = await EsportsService.getUpcomingGamesByCompetition(competitionId);
      return apiData.map((gameData) => Game.fromApi(gameData)).toList();
    } catch (e) {
      // Fallback to empty list if API fails
      return [];
    }
  }
}

final competitionGamesProvider = FutureProvider.family<List<Game>, int>((ref, competitionId) async {
  final notifier = ref.read(competitionGamesNotifierProvider.notifier);
  return await notifier.getGamesForCompetition(competitionId);
});

final competitionGamesNotifierProvider = AsyncNotifierProvider<CompetitionGamesNotifier, List<Game>>(
  () => CompetitionGamesNotifier(),
);
