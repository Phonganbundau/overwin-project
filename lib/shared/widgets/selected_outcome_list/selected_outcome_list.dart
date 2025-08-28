import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';
import 'package:overwin_mobile/shared/widgets/icon_circle.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';

class SelectedOutcomeList extends ConsumerWidget {
  final List<SelectedOutcome> outcomes;
  final Set<int> duplicateGameIds;
  const SelectedOutcomeList({super.key, required this.outcomes, this.duplicateGameIds = const {}});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white12, width: 0.5),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: outcomes.length,
        separatorBuilder: (context, index) => const Divider(height: 1, color: Colors.white12),
        itemBuilder: (context, index) {
          final outcome = outcomes[index];
          final isDuplicate = duplicateGameIds.contains(outcome.gameId);
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      spacing: 5,
                      children: [
                        IconCircle(
                          assetPath: outcome.esportIcon,
                          size: 18,
                          backgroundColor: AppColors.surfaceBubble,
                        ),
                        Text(
                          "${outcome.opponents[0].name} - ${outcome.opponents[1].name}",
                          style: TextStyle(
                            color: isDuplicate ? Colors.red : AppColors.surfaceText,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        ref.read(selectedOutcomesProvider.notifier).removeByOutcomeId(outcome.outcomeId);
                        // Vérifie si la liste est vide après suppression
                        final remaining = ref.read(selectedOutcomesProvider);
                        if (remaining.isEmpty) {
                          Navigator.of(context).pop();
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Icon(
                        Icons.close,
                        color: AppColors.surfaceText,
                        size: 18,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          outcome.outcomeName,
                          style: TextStyle(color: AppColors.surfaceText, fontSize: 16, height: 1),
                        ),
                        Text(
                          outcome.betTypeName,
                          style: TextStyle(color: AppColors.surfaceText, fontSize: 14, height: 1),
                        ),
                      ],
                    ),
                    Text(
                      outcome.outcomeOdd.toStringAsFixed(2).replaceAll('.', ','),
                      style: TextStyle(color: AppColors.surfaceText, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
