import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';

class SelectedOutcomesNotifier extends StateNotifier<List<SelectedOutcome>> {
  SelectedOutcomesNotifier() : super([]);

  void add(SelectedOutcome outcome) {
    state = [
      ...state.where((b) => b.outcomeId != outcome.outcomeId),
      outcome,
    ];
  }

  void removeByOutcomeId(int outcomeId) {
    state = state.where((b) => b.outcomeId != outcomeId).toList();
  }
}

final selectedOutcomesProvider = StateNotifierProvider<SelectedOutcomesNotifier, List<SelectedOutcome>>(
  (ref) => SelectedOutcomesNotifier(),
);
