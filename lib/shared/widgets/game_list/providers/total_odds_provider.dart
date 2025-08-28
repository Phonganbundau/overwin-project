import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'selected_outcomes_provider.dart';

final totalOddsProvider = Provider<String>((ref) {
  final outcomes = ref.watch(selectedOutcomesProvider);
  final gameIds = outcomes.map((o) => o.gameId).toList();
  final hasDuplicateGameId = gameIds.length != gameIds.toSet().length;

  if (hasDuplicateGameId) {
    return "-";
  } else if (outcomes.isEmpty) {
    return "0";
  } else {
    final total = outcomes.map((o) => o.outcomeOdd).reduce((a, b) => a * b);
    return total.toStringAsFixed(2).replaceAll('.', ',');
  }
}); 