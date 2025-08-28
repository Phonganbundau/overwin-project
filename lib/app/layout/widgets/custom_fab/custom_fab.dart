import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_fab/bets_summary_sheet.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/theme/app_modal_bottom_sheet.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/total_odds_provider.dart';

const double fabSize = 67.0;
const double badgePosition = -4;
const double badgeSize = 20;

class CustomFab extends ConsumerWidget {
  const CustomFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOutcomes = ref.watch(selectedOutcomesProvider);
    final totalText = ref.watch(totalOddsProvider);
    if (selectedOutcomes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        SizedBox(
          width: fabSize,
          height: fabSize,
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                sheetAnimationStyle: AnimationStyle(
                  duration: Duration(milliseconds: AppModalBottomSheet.bottomSheetDuration)
                ),
                builder: (_) => const BetsSummarySheet(),
              );
            },
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              totalText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.tertiary,
              ),
            ),
          ),
        ),
        Positioned(
          top: badgePosition,
          right: badgePosition,
          child: Container(
            width: badgeSize,
            height: badgeSize,
            decoration: BoxDecoration(
              color: AppColors.tertiary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                selectedOutcomes.length.toString(),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
