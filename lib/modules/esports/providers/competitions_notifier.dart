import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class CompetitionsNotifier extends AsyncNotifier<List<Competition>> {

  @override
  Future<List<Competition>> build() async {
    final apiData = await EsportsService.getAllCompetitions();
    return apiData.map((competitionData) => Competition.fromApi(competitionData)).toList();
  }
  
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiData = await EsportsService.getAllCompetitions();
      return apiData.map((competitionData) => Competition.fromApi(competitionData)).toList();
    });
  }
  

}

final competitionsProvider = AsyncNotifierProvider<CompetitionsNotifier, List<Competition>>(
  () => CompetitionsNotifier(),
);