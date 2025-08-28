import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_fab/bets_summary_sheet_content.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_fab/bets_summary_sheet_footer.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/theme/app_modal_bottom_sheet.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';

class BetsSummarySheet extends ConsumerWidget {
  const BetsSummarySheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOutcomes = ref.watch(selectedOutcomesProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    
    return FractionallySizedBox(
      widthFactor: 1.0,
      heightFactor: AppModalBottomSheet.modalBottomSheetHeightFactor,
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppModalBottomSheet.modalBottomSheetRadius),
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: BetsSummarySheetContent(outcomes: selectedOutcomes),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: bottomInset),
              child: BetsSummarySheetFooter(),
            ),
          ],
        ),
      ),
    );
  }
}
