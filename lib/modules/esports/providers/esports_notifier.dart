
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/models/e_sport.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class ESportsNotifier extends AsyncNotifier<List<ESport>> {
  @override
  Future<List<ESport>> build() async {
    try {
      final apiData = await EsportsService.getAllEsports();
      return apiData.map((esportData) => ESport.fromApi(esportData)).toList();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockData();
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final apiData = await EsportsService.getAllEsports();
        return apiData.map((esportData) => ESport.fromApi(esportData)).toList();
      } catch (e) {
        return _getMockData();
      }
    });
  }

  // Fallback mock data
  List<ESport> _getMockData() {
    return [
      ESport(
        id: 1,
        name: 'Rocket League',
        icon: 'assets/icons/rocket-league.png',
        competitions: [
          Competition(id: 1, name: 'Regional 1', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 2, name: 'Regional 2', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 3, name: 'Regional 3', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 4, name: 'Birmingham Major', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 5, name: 'Regional 1', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 6, name: 'Regional 2', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 7, name: 'Regional 3', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 8, name: 'Raleigh Major', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 9, name: 'Esports World Cup 2025', icon: '', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 10, name: 'RLCS 2025', icon: 'assets/icons/rlcs.png', esportId: 1, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 2,
        name: 'League of Legends',
        icon: 'assets/icons/lol.png',
        competitions: [
          Competition(id: 11, name: 'LEC Spring', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 12, name: 'LCK Spring', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 13, name: 'LPL Spring', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 14, name: 'LCS Spring', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 15, name: 'MSI 2025', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 16, name: 'LEC Summer', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 17, name: 'LCK Summer', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 18, name: 'LPL Summer', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 19, name: 'LCS Summer', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 20, name: 'Esports World Cup 2025', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 21, name: 'Worlds 2025', icon: '', esportId: 2, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 3,
        name: 'Dota 2',
        icon: 'assets/icons/dota.png',
        competitions: [
          Competition(id: 22, name: 'PGL Wallachia Season 1', icon: '', esportId: 3, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 23, name: 'PGL Wallachia Season 2', icon: '', esportId: 3, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 24, name: 'DreamLeague Season 23', icon: '', esportId: 3, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 25, name: 'Elite League', icon: '', esportId: 3, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 26, name: 'Riyadh Masters 2025', icon: '', esportId: 3, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 27, name: 'The International 2025', icon: '', esportId: 3, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 4,
        name: 'Counter-Strike 2',
        icon: 'assets/icons/cs2.png',
        competitions: [
          Competition(id: 28, name: 'BLAST Premier Spring Groups', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 29, name: 'IEM Katowice', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 30, name: 'RMR A/B/C', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 31, name: 'Copenhagen Major', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 32, name: 'ESL Pro League Season 19', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 33, name: 'BLAST Premier Spring Final', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 34, name: 'IEM Dallas', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 35, name: 'BLAST.tv Austin Major', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 36, name: 'IEM Cologne', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 37, name: 'ESL Pro League Season 20', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 38, name: 'BLAST Premier Fall Final', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 39, name: 'World Final', icon: '', esportId: 4, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 5,
        name: 'Fortnite',
        icon: 'assets/icons/fortnite.png',
        competitions: [
          Competition(id: 40, name: 'FNCS Major 1', icon: '', esportId: 5, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 41, name: 'FNCS Major 2', icon: '', esportId: 5, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 42, name: 'FNCS Major 3', icon: '', esportId: 5, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 43, name: 'FNCS Global Championship 2025', icon: '', esportId: 5, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 44, name: 'Esports World Cup 2025', icon: '', esportId: 5, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 6,
        name: 'Valorant',
        icon: 'assets/icons/valorant.png',
        competitions: [
          Competition(id: 45, name: 'VCT Challengers Split 1', icon: '', esportId: 6, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 46, name: 'VCT Masters Madrid', icon: '', esportId: 6, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 47, name: 'VCT Challengers Split 2', icon: '', esportId: 6, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 48, name: 'VCT Masters Shanghai', icon: '', esportId: 6, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 49, name: 'Esports World Cup 2025', icon: '', esportId: 6, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 50, name: 'Valorant Champions 2025', icon: '', esportId: 6, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 7,
        name: 'PUBG',
        icon: 'assets/icons/pubg.png',
        competitions: [
          Competition(id: 51, name: 'PMSL Europe Spring', icon: '', esportId: 7, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 52, name: 'PMSL Americas Spring', icon: '', esportId: 7, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 53, name: 'PMSL Asia Spring', icon: '', esportId: 7, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 54, name: 'PUBG Nations Cup', icon: '', esportId: 7, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 55, name: 'PUBG Mobile World Cup 2025', icon: '', esportId: 7, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 56, name: 'Esports World Cup 2025', icon: '', esportId: 7, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 8,
        name: 'Honor of Kings',
        icon: 'assets/icons/hok.png',
        competitions: [
          Competition(id: 57, name: 'Open Qualifiers Split 1', icon: '', esportId: 8, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 58, name: 'Open Qualifiers Split 2', icon: '', esportId: 8, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 59, name: 'Open Qualifiers Split 3', icon: '', esportId: 8, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 60, name: 'Pro League 2025', icon: '', esportId: 8, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 61, name: 'Honor of Kings World Champion Cup 2025', icon: '', esportId: 8, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 9,
        name: 'Rainbow Six Siege',
        icon: 'assets/icons/r6.png',
        competitions: [
          Competition(id: 62, name: 'Six Invitational 2025', icon: '', esportId: 9, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 63, name: 'BLAST R6 Major Manchester', icon: '', esportId: 9, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 64, name: 'BLAST R6 Major Riyadh', icon: '', esportId: 9, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 65, name: 'BLAST R6 Major Atlanta', icon: '', esportId: 9, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 10,
        name: 'Call of Duty',
        icon: 'assets/icons/cod.png',
        competitions: [
          Competition(id: 66, name: 'CDL Major 1', icon: '', esportId: 10, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 67, name: 'CDL Major 2', icon: '', esportId: 10, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 68, name: 'CDL Major 3', icon: '', esportId: 10, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 69, name: 'CDL Major 4', icon: '', esportId: 10, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 70, name: 'CDL Championship 2025', icon: '', esportId: 10, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 11,
        name: 'Overwatch',
        icon: 'assets/icons/overwatch.png',
        competitions: [
          Competition(id: 71, name: 'Overwatch Champions Series Preseason', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 72, name: 'OWCS Stage 1', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 73, name: 'OWCS Stage 2', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 74, name: 'OWCS Major 1', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 75, name: 'OWCS Stage 3', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 76, name: 'OWCS Major 2', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 77, name: 'OWCS Championship', icon: '', esportId: 11, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 12,
        name: 'Apex Legends',
        icon: 'assets/icons/apex.png',
        competitions: [
          Competition(id: 78, name: 'ALGS Split 1 Pro League', icon: '', esportId: 12, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 79, name: 'ALGS Split 1 Playoffs', icon: '', esportId: 12, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 80, name: 'ALGS Split 2 Pro League', icon: '', esportId: 12, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 81, name: 'ALGS Split 2 Playoffs', icon: '', esportId: 12, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 82, name: 'ALGS Championship 2025', icon: '', esportId: 12, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),

      ESport(
        id: 13,
        name: 'Teamfight Tactics',
        icon: 'assets/icons/tft.png',
        competitions: [
          Competition(id: 83, name: 'Rising Legends Golden Spatula Cup 1', icon: '', esportId: 13, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 84, name: 'Rising Legends Golden Spatula Cup 2', icon: '', esportId: 13, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 85, name: 'Rising Legends Golden Spatula Cup 3', icon: '', esportId: 13, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 86, name: 'TFT Dragonlands Championship', icon: '', esportId: 13, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
          Competition(id: 87, name: 'TFT Inkborn Fables Championship', icon: '', esportId: 13, startDate: DateTime(2025, 7, 14), endsAt: DateTime(2025, 7, 17)),
        ],
      ),
    ];
  }
}

final esportsProvider = AsyncNotifierProvider<ESportsNotifier, List<ESport>>(
  () => ESportsNotifier(),
);
