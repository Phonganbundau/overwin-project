import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:overwin_mobile/modules/esports/models/competition_market.dart';
import 'package:overwin_mobile/shared/services/api_service.dart';

/// Provider để lấy các kèo competition-level
final competitionMarketsProvider = FutureProvider.family<List<CompetitionMarket>, int>((ref, competitionId) async {
  final response = await http.get(
    Uri.parse('${ApiService.baseUrl}/esports/competitions/$competitionId/markets'),
    headers: await ApiService.getAuthHeaders(),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => CompetitionMarket.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load competition markets');
  }
});
