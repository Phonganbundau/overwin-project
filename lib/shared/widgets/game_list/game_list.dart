import 'package:flutter/material.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/theme/app_spacing.dart';
import 'package:overwin_mobile/shared/widgets/game_list/widgets/game_card.dart';

class GameList extends StatelessWidget {
  final List<Game> games;

  const GameList({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingFromSidesAndBars),
      itemCount: games.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.cardsSpacing),
      itemBuilder: (_, index) => GameCard(game: games[index]),
    );
  }
}
