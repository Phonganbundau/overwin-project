import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/modules/esports/models/competition_market.dart';
import 'package:overwin_mobile/modules/esports/providers/competition_markets_provider.dart';
import 'package:overwin_mobile/modules/bets/models/opponent.dart';
import 'package:overwin_mobile/modules/bets/models/selection.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/modules/esports/providers/competition_games_provider.dart';
import 'package:overwin_mobile/shared/widgets/game_list/game_list.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/theme/app_spacing.dart';

class CompetitionDetailsScreen extends ConsumerWidget {
  final Competition competition;

  const CompetitionDetailsScreen({super.key, required this.competition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const SizedBox(height: 10),
          _Header(competition: competition),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Matchs'),
                Tab(text: 'Compétition'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: TabBarView(
              children: [
                _GamesTab(competition: competition),
                _CompetitionBetsTab(competition: competition),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Competition competition;
  const _Header({required this.competition});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (competition.icon.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: competition.icon.startsWith('http')
              ? Image.network(
                  competition.icon,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.emoji_events, color: Colors.white, size: 36),
                )
              : Image.asset(
                  competition.icon,
                  width: 36,
                  height: 36,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.emoji_events, color: Colors.white, size: 36),
                ),
          ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            competition.name,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class _GamesTab extends ConsumerWidget {
  final Competition competition;
  const _GamesTab({required this.competition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final games = ref.watch(competitionGamesProvider(competition.id));
    return games.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text('Erreur : $e', style: const TextStyle(color: Colors.white))),
      data: (list) {
        if (list.isEmpty) {
          return const Center(
            child: Text('Aucun match pour cette compétition', style: TextStyle(color: Colors.white70)),
          );
        }
        return GameList(games: list);
      },
    );
  }
}

class _CompetitionBetsTab extends ConsumerWidget {
  final Competition competition;
  const _CompetitionBetsTab({required this.competition});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final marketsAsync = ref.watch(competitionMarketsProvider(competition.id));
    final selected = ref.watch(selectedOutcomesProvider);

    return marketsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Erreur de chargement: $error', 
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      data: (markets) {
        if (markets.isEmpty) {
          return const Center(
            child: Text(
              'Aucun pari disponible pour cette compétition', 
              style: TextStyle(color: Colors.white70),
            ),
          );
        }

        // Regrouper les marchés par type
        final groupedMarkets = <String, List<CompetitionMarket>>{};
        for (final market in markets) {
          if (!groupedMarkets.containsKey(market.type)) {
            groupedMarkets[market.type] = [];
          }
          groupedMarkets[market.type]!.add(market);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.paddingFromSidesAndBars),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: groupedMarkets.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Section(
                    title: _formatMarketType(entry.key),
                    children: _buildSelectionsForMarkets(entry.value, selected, ref),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  List<Widget> _buildSelectionsForMarkets(List<CompetitionMarket> markets, List<SelectedOutcome> selected, WidgetRef ref) {
    final widgets = <Widget>[];
    
    for (final market in markets) {
      for (final selection in market.selections) {
        final isSelected = selected.any((s) => s.outcomeId == selection.id);
        widgets.add(
          _OutcomeTile(
            label: selection.name,
            odd: selection.odd,
            isSelected: isSelected,
            onTap: () {
              _toggleSelection(ref, isSelected, selection, market, competition);
            },
          ),
        );
      }
    }
    
    return widgets;
  }

  String _formatMarketType(String type) {
    // Convertir le type technique en nom lisible
    switch (type) {
      case 'tournament_winner':
        return 'Vainqueur du tournoi';
      case 'mvp':
        return 'Meilleur joueur du tournoi';
      default:
        return type.replaceAll('_', ' ').capitalize();
    }
  }

  void _toggleSelection(WidgetRef ref, bool isSelected, Selection selection, CompetitionMarket market, Competition competition) {
    final notifier = ref.read(selectedOutcomesProvider.notifier);
    if (isSelected) {
      notifier.removeByOutcomeId(selection.id);
    } else {
      final selected = SelectedOutcome(
        outcomeId: selection.id,
        gameId: -market.id, // identifiant unique négatif pour pari compétition
        esportIcon: competition.icon,
        opponents: [
          Opponent(id: -1, name: 'Tournoi', logo: competition.icon),
          Opponent(id: -2, name: competition.name, logo: competition.icon),
        ],
        outcomeName: selection.name,
        outcomeOdd: selection.odd,
        betTypeName: _formatMarketType(market.type),
      );
      notifier.add(selected);
    }
  }


}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _OutcomeTile extends StatelessWidget {
  final String label;
  final double odd;
  final bool isSelected;
  final VoidCallback onTap;
  const _OutcomeTile({required this.label, required this.odd, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.secondary : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: isSelected ? AppColors.surfaceText : AppColors.primary, fontSize: 14),
              ),
            ),
            Text(
              odd.toStringAsFixed(2).replaceAll('.', ','),
              style: TextStyle(color: isSelected ? AppColors.surfaceText : AppColors.secondary, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
