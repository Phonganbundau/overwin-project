
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
      if (apiData.isNotEmpty) {
        return apiData.map((esportData) => ESport.fromApi(esportData)).toList();
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
      final apiData = await EsportsService.getAllEsports();
      if (apiData.isNotEmpty) {
        state = AsyncValue.data(apiData.map((esportData) => ESport.fromApi(esportData)).toList());
      } else {
        state = const AsyncValue.data([]);
      }
    } catch (e) {
      state = const AsyncValue.data([]);
    }
  }


}

final esportsProvider = AsyncNotifierProvider<ESportsNotifier, List<ESport>>(
  () => ESportsNotifier(),
);

