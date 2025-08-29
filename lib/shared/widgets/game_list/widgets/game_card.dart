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
            GameTitle(
              esportIcon: game.esportIcon,
              competitionIcon: game.competitionIcon,
              competitionName: game.competitionName,
              name: game.name.isNotEmpty ? game.name : 'Unknown Game',
            ),
            game.imageUrl.isEmpty
                ? Padding(
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
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.network(
                            game.imageUrl,
                            width: double.infinity,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (ctx, error, stack) {
                              return Container(
                                width: double.infinity,
                                height: 220,
                                alignment: Alignment.topCenter,
                                child: const Icon(
                                  Icons.error,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: const [0.3, 1.0],
                                  colors: [Colors.transparent, Colors.black],
                                ),
                              ),
                            ),
                          ),

                          Positioned(
                            left: 0,
                            bottom: 0,
                            right: 0,
                            child: Column(
                              children: [
                                GameInfo(opponents: game.opponents, scheduledAt: game.scheduledAt),
                                GameOdds(
                                  opponents: game.opponents, 
                                  markets: game.markets, 
                                  gameId: game.id, 
                                  esportIcon: game.esportIcon
                                )
                              ],
                            )
                          ),
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
