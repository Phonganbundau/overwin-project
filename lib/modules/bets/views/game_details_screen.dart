import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/modules/bets/models/market.dart';
import 'package:overwin_mobile/modules/bets/models/selection.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/widgets/game_list/models/selected_outcome.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_fab/custom_fab.dart';
import 'package:overwin_mobile/shared/services/api_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameDetailsScreen extends ConsumerStatefulWidget {
  final Game game;
  const GameDetailsScreen({super.key, required this.game});

  @override
  ConsumerState<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends ConsumerState<GameDetailsScreen> {
  List<Market> markets = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchOdds();
  }

  Future<void> _fetchOdds() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/esports/games/${widget.game.id}/odds'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> marketsJson = json.decode(response.body);
        final List<Market> fetchedMarkets = marketsJson
            .map((marketJson) => Market.fromJson(marketJson))
            .toList();
        
        setState(() {
          markets = fetchedMarkets;
          isLoading = false;
        });
      } else {
        setState(() {
          error = 'Failed to load odds: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading odds: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (error != null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                error!,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _fetchOdds,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          const SizedBox(height: 20),
          
          // Row 1: esport.icon, competition.icon, competition.name, game.name
          Row(
            children: [
              // esport.icon
              if (widget.game.esportIcon.isNotEmpty)
                ClipOval(
                  child: widget.game.esportIcon.startsWith('http')
                    ? Image.network(
                        widget.game.esportIcon,
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, color: Colors.white, size: 24),
                      )
                    : Image.asset(
                        widget.game.esportIcon,
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, color: Colors.white, size: 24),
                      ),
                ),
              
              const SizedBox(width: 8),
              
              // competition.icon
              if (widget.game.competitionIcon.isNotEmpty)
                ClipOval(
                  child: widget.game.competitionIcon.startsWith('http')
                    ? Image.network(
                        widget.game.competitionIcon,
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                      )
                    : Image.asset(
                        widget.game.competitionIcon,
                        height: 24,
                        width: 24,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.emoji_events, color: Colors.white, size: 24),
                      ),
                ),
              
              const SizedBox(width: 8),
              
              // competition.name
        Text(
                widget.game.competitionName.isNotEmpty ? widget.game.competitionName : 'Competition',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              
              const SizedBox(width: 8),
              
              // game.name
              Expanded(
                child: Text(
                  widget.game.name.isNotEmpty ? widget.game.name : 'Unknown Game',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Row 2: opponent 1, date, opponent 2
          Center(
            child: Text(
              '${widget.game.opponents.isNotEmpty ? widget.game.opponents[0].name : 'Team 1'} ${widget.game.scheduledAt != null ? _formatTime(widget.game.scheduledAt!) : 'TBD'} ${widget.game.opponents.length > 1 ? widget.game.opponents[1].name : 'Team 2'}',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          
          const SizedBox(height: 30),
          
          // Markets block - For beta, only show 1X2 market
          if (markets.isNotEmpty)
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: market.name
                    Row(
                      children: [
                        Expanded(
            child: Text(
                            markets[0].name,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Row 2: selections with odds (1X2 market)
                    if (markets.isNotEmpty && markets[0].selections.isNotEmpty)
                      Row(
                        children: [
                          // Selection 1: Home team
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (markets.isNotEmpty && markets[0].selections.isNotEmpty) {
                                  final selection = markets[0].selections[0];
                                  final currentOutcomes = ref.read(selectedOutcomesProvider);
                                  
                                  // Check if this selection is already selected
                                  final isAlreadySelected = currentOutcomes.any((outcome) => 
                                    outcome.outcomeId == selection.id && outcome.gameId == widget.game.id
                                  );
                                  
                                  if (isAlreadySelected) {
                                    // If already selected, remove it
                                    ref.read(selectedOutcomesProvider.notifier).removeByOutcomeId(selection.id);
                                  } else {
                                    // If not selected, add it
                                    final selectedOutcome = SelectedOutcome(
                                      outcomeId: selection.id,
                                      gameId: widget.game.id,
                                      esportIcon: widget.game.esportIcon,
                                      opponents: widget.game.opponents,
                                      outcomeName: widget.game.opponents.isNotEmpty ? widget.game.opponents[0].name : 'Team 1',
                                      outcomeOdd: selection.odd,
                                      betTypeName: markets[0].name,
                                    );
                                    ref.read(selectedOutcomesProvider.notifier).add(selectedOutcome);
                                  }
                                }
                              },
                              child: Consumer(
                                builder: (context, ref, child) {
                                  final currentOutcomes = ref.watch(selectedOutcomesProvider);
                                  final isSelected = currentOutcomes.any((outcome) => 
                                    outcome.outcomeId == markets[0].selections[0].id && outcome.gameId == widget.game.id
                                  );
                                  
                                  return Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 7),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.secondary : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                      child: Column(
                                        children: [
                                          Text(
                                            widget.game.opponents.isNotEmpty ? widget.game.opponents[0].name : 'Team 1',
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
                                            markets[0].selections.isNotEmpty 
                                                ? markets[0].selections[0].odd.toStringAsFixed(2).replaceAll('.', ',')
                                                : '0,00',
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
                                  );
                                },
                              ),
                            ),
                          ),
                          
                          if (markets[0].selections.length > 1) ...[
                            const SizedBox(width: 12),
                            
                            // Selection 2: Draw
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (markets.isNotEmpty && markets[0].selections.length > 1) {
                                    final selection = markets[0].selections[1];
                                    final currentOutcomes = ref.read(selectedOutcomesProvider);
                                    
                                    // Check if this selection is already selected
                                    final isAlreadySelected = currentOutcomes.any((outcome) => 
                                      outcome.outcomeId == selection.id && outcome.gameId == widget.game.id
                                    );
                                    
                                    if (isAlreadySelected) {
                                      // If already selected, remove it
                                      ref.read(selectedOutcomesProvider.notifier).removeByOutcomeId(selection.id);
                                    } else {
                                      // If not selected, add it
                                      final selectedOutcome = SelectedOutcome(
                                        outcomeId: selection.id,
                                        gameId: widget.game.id,
                                        esportIcon: widget.game.esportIcon,
                                        opponents: widget.game.opponents,
                                        outcomeName: selection.name,
                                        outcomeOdd: selection.odd,
                                        betTypeName: markets[0].name,
                                      );
                                      ref.read(selectedOutcomesProvider.notifier).add(selectedOutcome);
                                    }
                                  }
                                },
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    final currentOutcomes = ref.watch(selectedOutcomesProvider);
                                    final isSelected = currentOutcomes.any((outcome) => 
                                      outcome.outcomeId == markets[0].selections[1].id && outcome.gameId == widget.game.id
                                    );
                                    
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.secondary : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                        child: Column(
                                          children: [
                                            Text(
                                              markets[0].selections[1].name,
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
                                              markets[0].selections[1].odd.toStringAsFixed(2).replaceAll('.', ','),
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                          
                          if (markets[0].selections.length > 2) ...[
                            const SizedBox(width: 12),
                            
                            // Selection 3: Away team
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (markets.isNotEmpty && markets[0].selections.length > 2) {
                                    final selection = markets[0].selections[2];
                                    final currentOutcomes = ref.read(selectedOutcomesProvider);
                                    
                                    // Check if this selection is already selected
                                    final isAlreadySelected = currentOutcomes.any((outcome) => 
                                      outcome.outcomeId == selection.id && outcome.gameId == widget.game.id
                                    );
                                    
                                    if (isAlreadySelected) {
                                      // If already selected, remove it
                                      ref.read(selectedOutcomesProvider.notifier).removeByOutcomeId(selection.id);
                                    } else {
                                      // If not selected, add it
                                      final selectedOutcome = SelectedOutcome(
                                        outcomeId: selection.id,
                                        gameId: widget.game.id,
                                        esportIcon: widget.game.esportIcon,
                                        opponents: widget.game.opponents,
                                        outcomeName: widget.game.opponents.length > 1 ? widget.game.opponents[1].name : 'Team 2',
                                        outcomeOdd: selection.odd,
                                        betTypeName: markets[0].name,
                                      );
                                      ref.read(selectedOutcomesProvider.notifier).add(selectedOutcome);
                                    }
                                  }
                                },
                                child: Consumer(
                                  builder: (context, ref, child) {
                                    final currentOutcomes = ref.watch(selectedOutcomesProvider);
                                    final isSelected = currentOutcomes.any((outcome) => 
                                      outcome.outcomeId == markets[0].selections[2].id && outcome.gameId == widget.game.id
                                    );
                                    
                                    return Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 7),
                                      decoration: BoxDecoration(
                                        color: isSelected ? AppColors.secondary : Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                        child: Column(
                                          children: [
                                            Text(
                                              widget.game.opponents.length > 1 ? widget.game.opponents[1].name : 'Team 2',
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
                                              markets[0].selections[2].odd.toStringAsFixed(2).replaceAll('.', ','),
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
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
            ),
          ),
        ),
      ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}


