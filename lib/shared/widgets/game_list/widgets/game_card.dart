import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/widgets/game_list/widgets/game_info.dart';
import 'package:overwin_mobile/shared/widgets/game_list/widgets/game_odds.dart';
import 'package:overwin_mobile/shared/widgets/game_list/widgets/game_title.dart';

class GameCard extends StatelessWidget {
  final Game game;

  const GameCard({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/game-details', extra: game);
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: game.imageUrl.isNotEmpty 
                  ? Image.asset(
                      game.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.sports_esports, size: 50),
                        );
                      },
                    )
                  : Container(
                      height: 120,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(Icons.sports_esports, size: 50),
                    ),
            ),
            GameTitle(
              esportIcon: game.esportIcon.isNotEmpty ? game.esportIcon : 'assets/icons/rocket-league-logo.png',
              competitionIcon: game.competitionIcon.isNotEmpty ? game.competitionIcon : 'assets/icons/rlcs.png',
              competitionName: game.competitionName.isNotEmpty ? game.competitionName : 'Competition',
              name: game.name.isNotEmpty ? game.name : 'Unknown Game',
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GameInfo(opponents: game.opponents, scheduledAt: game.scheduledAt),
                    GameOdds(
                      opponents: game.opponents, 
                      markets: game.markets, 
                      gameId: game.id, 
                      esportIcon: game.esportIcon.isNotEmpty ? game.esportIcon : 'assets/icons/rocket-league-logo.png'
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
