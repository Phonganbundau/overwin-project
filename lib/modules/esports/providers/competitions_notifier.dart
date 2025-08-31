import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class CompetitionsNotifier extends AsyncNotifier<List<Competition>> {

  @override
  Future<List<Competition>> build() async {
    try {
      final apiData = await EsportsService.getAllCompetitions();
      if (apiData.isNotEmpty) {
        return apiData.map((competitionData) => Competition.fromApi(competitionData)).toList();
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
      final apiData = await EsportsService.getAllCompetitions();
      if (apiData.isNotEmpty) {
        state = AsyncValue.data(apiData.map((competitionData) => Competition.fromApi(competitionData)).toList());
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e) {
      state = const AsyncValue.data([]);
    }
  }
  

}

final competitionsProvider = AsyncNotifierProvider<CompetitionsNotifier, List<Competition>>(
  () => CompetitionsNotifier(),
);