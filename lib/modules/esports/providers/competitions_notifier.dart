import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class CompetitionsNotifier extends AsyncNotifier<List<Competition>> {

  @override
  Future<List<Competition>> build() async {
    try {
      final apiData = await EsportsService.getAllCompetitions();
      return apiData.map((competitionData) => Competition.fromApi(competitionData)).toList();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getMockData();
    }
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      try {
        final apiData = await EsportsService.getAllCompetitions();
        return apiData.map((competitionData) => Competition.fromApi(competitionData)).toList();
      } catch (e) {
        return _getMockData();
      }
    });
  }
  
  // Fallback mock data
  List<Competition> _getMockData() {
    return [
      Competition(
        id: 1, 
        name: 'RLCS 2025', 
        icon: 'assets/icons/rlcs.png', 
        esportId: 1, 
        startDate: DateTime(2025, 7, 14), 
        endsAt: DateTime(2025, 7, 17)
      ),
    ];
  }
}

final competitionsProvider = AsyncNotifierProvider<CompetitionsNotifier, List<Competition>>(
  () => CompetitionsNotifier(),
);