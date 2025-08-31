import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/modules/bets/models/market.dart';
import 'package:overwin_mobile/modules/bets/models/selection.dart';
import 'package:overwin_mobile/modules/bets/models/opponent.dart';
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
  
  // Map to track expanded state of each market
  final Map<String, bool> _expandedMarkets = {};

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
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, color: Colors.white, size: 20),
                      )
                    : Image.asset(
                        widget.game.esportIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.sports_esports, color: Colors.white, size: 20),
                      ),
                ),
              
              const SizedBox(width: 0),
              
              // competition.icon
              if (widget.game.competitionIcon.isNotEmpty)
                ClipOval(
                  child: widget.game.competitionIcon.startsWith('http')
                    ? Image.network(
                        widget.game.competitionIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                      )
                    : Image.asset(
                        widget.game.competitionIcon,
                        height: 20,
                        width: 20,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.emoji_events, color: Colors.white, size: 20),
                      ),
                ),
              
              const SizedBox(width: 8),
              
              // competition.name
              Expanded(
                child: Text(
                  widget.game.competitionName.isNotEmpty ? widget.game.competitionName : 'Competition',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Row 2: opponent 1, date, opponent 2
          Row(
            children: [
              // Opponent 1
              Expanded(
                child: Text(
                  widget.game.opponents.isNotEmpty ? widget.game.opponents[0].name : 'Team 1',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                ),
              ),
              
              // Date (centered)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  widget.game.scheduledAt != null ? _formatTime(widget.game.scheduledAt!) : 'TBD',
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              
              // Opponent 2
              Expanded(
                child: Text(
                  widget.game.opponents.length > 1 ? widget.game.opponents[1].name : 'Team 2',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 30),
          
          // Markets block - Show all available markets
          if (markets.isNotEmpty)
            ...markets.map((market) => Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
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
                            market.name,
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Row 2: selections with odds
                    if (market.selections.isNotEmpty)
                      // Special layout for "Score Final (Manche)" market
                      if (market.name == "Score Final (Manche)") 
                        _buildExpandableSelectionGrid(
                          market.selections,
                          ref,
                          widget.game.id,
                          widget.game.esportIcon,
                          widget.game.opponents,
                          market.name,
                          true // Use score selection pair layout
                        )
                      else
                        // Default layout for other markets
                        _buildExpandableSelectionGrid(
                          market.selections,
                          ref,
                          widget.game.id,
                          widget.game.esportIcon,
                          widget.game.opponents,
                          market.name,
                          false // Use regular selection item layout
                        ),
                  ],
                ),
              ),
            )),
          ],
      ),
    );
  }
  
  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Helper method to build a selection item for regular markets
  Widget _buildSelectionItem(
    Selection selection,
    WidgetRef ref,
    int gameId,
    String esportIcon,
    List<Opponent> opponents,
    String marketName,
  ) {
    return GestureDetector(
      onTap: () {
        final currentOutcomes = ref.read(selectedOutcomesProvider);
        
        // Check if this selection is already selected
        final isAlreadySelected = currentOutcomes.any((outcome) => 
          outcome.outcomeId == selection.id && outcome.gameId == gameId
        );
        
        if (isAlreadySelected) {
          // If already selected, remove it
          ref.read(selectedOutcomesProvider.notifier).removeByOutcomeId(selection.id);
        } else {
          // If not selected, add it
          final selectedOutcome = SelectedOutcome(
            outcomeId: selection.id,
            gameId: gameId,
            esportIcon: esportIcon,
            opponents: opponents,
            outcomeName: selection.name,
            outcomeOdd: selection.odd,
            betTypeName: marketName,
          );
          ref.read(selectedOutcomesProvider.notifier).add(selectedOutcome);
        }
      },
      child: Consumer(
        builder: (context, ref, child) {
          final currentOutcomes = ref.watch(selectedOutcomesProvider);
          final isSelected = currentOutcomes.any((outcome) => 
            outcome.outcomeId == selection.id && outcome.gameId == gameId
          );
          
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Column(
                children: [
                  Text(
                    selection.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.1,
                      color: isSelected
                          ? AppColors.surfaceText
                          : AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    selection.odd.toStringAsFixed(2).replaceAll('.', ','),
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
    );
  }

  // Helper method to build a score selection pair for "Score Final (Manche)" market
  Widget _buildScoreSelectionPair(
    Selection selection,
    WidgetRef ref,
    int gameId,
    String esportIcon,
    List<Opponent> opponents,
    String marketName,
  ) {
    final currentOutcomes = ref.watch(selectedOutcomesProvider);
    final isSelected = currentOutcomes.any((outcome) => 
      outcome.outcomeId == selection.id && outcome.gameId == gameId
    );

    // Parse the score from selection name (e.g., "3 - 0", "3 - 1")
    final parts = selection.name.split(' - ');
    final score1 = parts.isNotEmpty ? parts[0] : "";
    final score2 = parts.length > 1 ? parts[1] : "";
    
    return Row(
      children: [
        // Score label - not clickable
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          alignment: Alignment.center,
          child: Text(
            selection.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
        ),
        
        // Horizontal line
        Expanded(
          child: Container(
            height: 1,
            color: Colors.white24,
          ),
        ),
        
        // Odds part - clickable
        GestureDetector(
          onTap: () {
            if (isSelected) {
              ref.read(selectedOutcomesProvider.notifier).removeByOutcomeId(selection.id);
            } else {
              final selectedOutcome = SelectedOutcome(
                outcomeId: selection.id,
                gameId: gameId,
                esportIcon: esportIcon,
                opponents: opponents,
                outcomeName: selection.name,
                outcomeOdd: selection.odd,
                betTypeName: marketName,
              );
              ref.read(selectedOutcomesProvider.notifier).add(selectedOutcome);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.secondary : Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              selection.odd.toStringAsFixed(2).replaceAll('.', ','),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.surfaceText : AppColors.secondary,
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  // Helper method to build expandable selection grid
  Widget _buildExpandableSelectionGrid(
    List<Selection> selections,
    WidgetRef ref,
    int gameId,
    String esportIcon,
    List<Opponent> opponents,
    String marketName,
    bool useScoreLayout,
  ) {
    // Create a unique key for this market
    final String marketKey = '$marketName-$gameId';
    
    // Default to showing only 2 rows (4 items)
    final bool isExpanded = _expandedMarkets[marketKey] ?? false;
    final int visibleRows = isExpanded ? selections.length : 2;
    final int itemsPerRow = 2;
    final int visibleItems = visibleRows * itemsPerRow;
    
    // Check if we need to show the "Show More" button
    final bool needsExpansion = selections.length > 4;
    
    return Column(
      children: [
        // Visible selections grid
        for (int i = 0; i < selections.length; i += itemsPerRow) 
          if (i < visibleItems) // Only show up to visibleItems
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  // Left item
                  Expanded(
                    child: i < selections.length ? 
                      useScoreLayout 
                        ? _buildScoreSelectionPair(
                            selections[i], 
                            ref, 
                            gameId, 
                            esportIcon, 
                            opponents, 
                            marketName
                          )
                        : _buildSelectionItem(
                            selections[i], 
                            ref, 
                            gameId, 
                            esportIcon, 
                            opponents, 
                            marketName
                          )
                      : const SizedBox(),
                  ),
                  const SizedBox(width: 8),
                  // Right item (if available)
                  Expanded(
                    child: (i + 1) < selections.length && (i + 1) < visibleItems ?
                      useScoreLayout 
                        ? _buildScoreSelectionPair(
                            selections[i + 1], 
                            ref, 
                            gameId, 
                            esportIcon, 
                            opponents, 
                            marketName
                          )
                        : _buildSelectionItem(
                            selections[i + 1], 
                            ref, 
                            gameId, 
                            esportIcon, 
                            opponents, 
                            marketName
                          )
                      : const SizedBox(),
                  ),
                ],
              ),
            ),
            
        // Show More/Less button if needed
        if (needsExpansion)
          GestureDetector(
            onTap: () {
              setState(() {
                _expandedMarkets[marketKey] = !isExpanded;
              });
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 4),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white70,
                    size: 35,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}