import 'package:flutter/material.dart';
import 'package:overwin_mobile/modules/bets/models/opponent.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/widgets/game_list/widgets/game_time.dart';
import 'package:overwin_mobile/shared/widgets/icon_circle.dart';

const double oddButtonVerticalPadding = 10;
const double oddButtonHorizontalPadding = 25;

class GameInfo extends StatelessWidget {
  final List<Opponent> opponents;
  final DateTime scheduledAt;

  const GameInfo({
    super.key,
    required this.opponents,
    required this.scheduledAt,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure we have at least 2 opponents
    if (opponents.length < 2) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Information non disponible',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: oddButtonHorizontalPadding,
        vertical: oddButtonVerticalPadding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GameOpponent(
            oppName: opponents[0].name.isNotEmpty ? opponents[0].name : 'Team 1', 
            oppLogo: opponents[0].logo.isNotEmpty ? opponents[0].logo : 'assets/icons/kc-logo.png'
          ),
          GameTime(scheduledAt: scheduledAt),
          GameOpponent(
            oppName: opponents[1].name.isNotEmpty ? opponents[1].name : 'Team 2', 
            oppLogo: opponents[1].logo.isNotEmpty ? opponents[1].logo : 'assets/icons/m8-logo.png'
          ),
        ],
      ),
    );
  }
}

class GameOpponent extends StatelessWidget {
  final String oppName;
  final String oppLogo;

  const GameOpponent({super.key, required this.oppName, required this.oppLogo});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 90,
      child: Column(
        children: [
          IconCircle(
            assetPath: oppLogo.isNotEmpty ? oppLogo : 'assets/icons/kc-logo.png', 
            size: 42, 
            backgroundColor: Colors.white
          ),
          Text(
            oppName.isNotEmpty ? oppName : 'Unknown Team',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.surfaceText,
              height: 2,
            ),
          ),
        ],
      ),
    );
  }
}