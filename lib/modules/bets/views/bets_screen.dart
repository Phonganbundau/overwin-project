import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/providers/games.notifier.dart';
import 'package:overwin_mobile/shared/widgets/game_list/game_list.dart';
import 'package:overwin_mobile/shared/widgets/custom_circular_progress_indicator.dart';

class BetsScreen extends ConsumerWidget {
  const BetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(gamesProvider);

    return games.when(
      data: (gamesList) => Column(
        children: [
          Expanded(child: GameList(games: gamesList)),
        ],
      ),
      loading: () => const Center(child: CustomCircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erreur : $e')),
    );
  }
}
