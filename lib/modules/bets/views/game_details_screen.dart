import 'package:flutter/material.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';

class GameDetailsScreen extends StatelessWidget {
  final Game game;
  const GameDetailsScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Compétition - ${game.name}',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Aucun pari disponible pour la bêta',
              style: TextStyle(color: Colors.white70),
            ),
          ),
        ),
      ],
    );
  }
}


