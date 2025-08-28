import 'package:flutter/material.dart';
import 'package:overwin_mobile/shared/theme/app_spacing.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';
import 'package:overwin_mobile/shared/widgets/selected_outcome_list/selected_outcome_list.dart';

class BetsSummarySheetContent extends StatelessWidget {
  final List<SelectedOutcome> outcomes;
  const BetsSummarySheetContent({super.key, required this.outcomes});

  @override
  Widget build(BuildContext context) {
    // Calcule les gameId en doublon
    final gameIdCounts = <int, int>{};
    for (final o in outcomes) {
      gameIdCounts[o.gameId] = (gameIdCounts[o.gameId] ?? 0) + 1;
    }
    final duplicateGameIds = gameIdCounts.entries
        .where((e) => e.value > 1)
        .map((e) => e.key)
        .toSet();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingFromSidesAndBars),
        child: SizedBox(
          width: double.infinity,
          child: SelectedOutcomeList(
            outcomes: outcomes,
            duplicateGameIds: duplicateGameIds,
          ),
        ),
      ),
    );
  }
}