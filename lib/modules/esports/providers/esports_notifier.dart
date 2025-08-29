
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/models/e_sport.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/shared/services/esports_service.dart';

class ESportsNotifier extends AsyncNotifier<List<ESport>> {
  @override
  Future<List<ESport>> build() async {
    final apiData = await EsportsService.getAllEsports();
    return apiData.map((esportData) => ESport.fromApi(esportData)).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final apiData = await EsportsService.getAllEsports();
      return apiData.map((esportData) => ESport.fromApi(esportData)).toList();
    });
  }


}

final esportsProvider = AsyncNotifierProvider<ESportsNotifier, List<ESport>>(
  () => ESportsNotifier(),
);

