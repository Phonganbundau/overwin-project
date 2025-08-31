import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/opponent.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';

const Color oddButtonColor = Colors.white;
const Color oddButtonTextColor = Colors.white;
const double oddButtonBottomPadding = 10;
const double oddButtonSidesPadding = 5;

class GameOdds extends StatelessWidget {
  final List<Opponent> opponents;
  final List<dynamic> markets;
  final int gameId;
  final String esportIcon;

  const GameOdds({
    super.key,
    required this.opponents,
    required this.markets,
    required this.gameId,
    required this.esportIcon,
  });

  @override
  Widget build(BuildContext context) {
    // Use markets from API if available, otherwise fall back to mock data
    List<Map<String, dynamic>> outcomes = [];
    
    try {
      if (markets.isNotEmpty) {
        // Extract selections from markets - only from 1X2 market
        for (var market in markets) {
          if (market != null && market is Map<String, dynamic>) {
            // Check if this is a 1X2 market
            var marketType = market['type'];
            if (marketType == null || marketType.toString() != "1X2") {
              continue; // Skip non-1X2 markets
            }
            
            var selections = market['selections'];
            if (selections != null && selections is List) {
              for (var selection in selections) {
                if (selection != null && selection is Map<String, dynamic>) {
                  var id = selection['id'];
                  var name = selection['name'];
                  var odd = selection['odd'];
                  var marketName = market['name'];
                  
                  // Only add if all required fields are present
                  if (id != null && name != null && odd != null && marketName != null) {
                    outcomes.add({
                      'id': id,
                      'name': name.toString(),
                      'oddValue': odd is num ? odd.toDouble() : 1.0,
                      'betTypeName': marketName.toString(),
                    });
                  }
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error parsing markets: $e');
    }
    
    // If no valid outcomes available, return empty widget
    if (outcomes.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(
        bottom: oddButtonBottomPadding,
        left: oddButtonSidesPadding,
        right: oddButtonSidesPadding,
      ),
      child: Row(
        children: outcomes.map((outcome) {
          return Expanded(
            child: _OddButton(
              outcome: outcome,
              gameId: gameId,
              opponents: opponents,
              esportIcon: esportIcon.isNotEmpty ? esportIcon : 'assets/icons/rocket-league-logo.png',
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OddButton extends ConsumerStatefulWidget {
  final Map<String, dynamic> outcome;
  final int gameId;
  final List<Opponent> opponents;
  final String esportIcon;

  const _OddButton({
    super.key,
    required this.outcome,
    required this.gameId,
    required this.opponents,
    required this.esportIcon,
  });

  @override
  ConsumerState<_OddButton> createState() => _OddButtonState();
}

class _OddButtonState extends ConsumerState<_OddButton> {
  @override
  Widget build(BuildContext context) {
    try {
      final selectedOutcomes = ref.watch(selectedOutcomesProvider);
      final isSelected = selectedOutcomes.any((b) => b.outcomeId == widget.outcome['id']);

      return GestureDetector(
        onTap: () {
          try {
            final outcome = SelectedOutcome(
              outcomeId: widget.outcome['id'] ?? 0,
              gameId: widget.gameId,
              esportIcon: widget.esportIcon.isNotEmpty ? widget.esportIcon : 'assets/icons/rocket-league-logo.png',
              opponents: widget.opponents,
              outcomeName: widget.outcome['name']?.toString() ?? 'Unknown',
              outcomeOdd: (widget.outcome['oddValue'] is num) 
                  ? widget.outcome['oddValue'].toDouble() 
                  : 1.0,
              betTypeName: widget.outcome['betTypeName']?.toString() ?? 'Unknown',
            );
            final notifier = ref.read(selectedOutcomesProvider.notifier);
            if (isSelected) {
              notifier.removeByOutcomeId(widget.outcome['id']);
            } else {
              notifier.add(outcome);
            }
          } catch (e) {
            print('Error handling outcome selection: $e');
          }
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.secondary : oddButtonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Column(
              children: [
                Text(
                  widget.outcome['name']?.toString() ?? 'Unknown',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.1,
                    color: isSelected
                        ? AppColors.surfaceText
                        : AppColors.primary,
                  ),
                ),
                Text(
                  (widget.outcome['oddValue'] is num) 
                      ? widget.outcome['oddValue'].toStringAsFixed(2).replaceAll('.', ',')
                      : '1.00',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? AppColors.surfaceText
                        : AppColors.secondary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } catch (e) {
      print('Error building _OddButton: $e');
      // Return a fallback button if there's an error
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            color: oddButtonColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            child: Column(
              children: [
                Text(
                  'Error',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.1,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '1.00',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondary,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
