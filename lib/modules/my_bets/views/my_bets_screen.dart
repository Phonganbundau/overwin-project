import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/my_bets/models/bet.dart';
import 'package:overwin_mobile/modules/my_bets/models/bet_selection.dart';
import 'package:overwin_mobile/modules/my_bets/providers/bets_provider.dart';

import 'package:overwin_mobile/shared/theme/app_colors.dart';

class MyBetsScreen extends ConsumerStatefulWidget {
  const MyBetsScreen({super.key});

  @override
  ConsumerState<MyBetsScreen> createState() => _MyBetsScreenState();
}

class _MyBetsScreenState extends ConsumerState<MyBetsScreen> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _currentTabIndex = 0;
  
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    
    // Đăng ký observer
    WidgetsBinding.instance.addObserver(this);
    
    // Refresh tab "En cours" khi mở screen lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(refreshBetsProvider.notifier).refreshOngoingBets();
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh khi app được resume và đang ở tab "En cours"
    if (state == AppLifecycleState.resumed && _currentTabIndex == 0) {
      ref.read(refreshBetsProvider.notifier).refreshOngoingBets();
    }
  }
  
  void forceRefresh() {
    if (_currentTabIndex == 0) {
      ref.read(refreshBetsProvider.notifier).refreshOngoingBets();
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    // Remove observer
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentTabIndex = _tabController.index;
      });
      
      // Auto-refresh data khi chuyển tab
      _refreshCurrentTab();
    }
  }

  void _refreshCurrentTab() {
    switch (_currentTabIndex) {
      case 0: // En cours
        ref.read(refreshBetsProvider.notifier).refreshOngoingBets();
        break;
      case 1: // Terminés
        ref.read(refreshBetsProvider.notifier).refreshFinishedBets();
        break;
      case 2: // Gagnés
        ref.read(refreshBetsProvider.notifier).refreshWonBets();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF222327),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              onTap: (index) {
                setState(() {
                  _currentTabIndex = index;
                });
                // Refresh data khi tap vào tab
                _refreshCurrentTab();
              },
              tabs: const [
                Tab(text: 'En cours'),
                Tab(text: 'Terminés'),
                Tab(text: 'Gagnés'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _OngoingBetsTab(),
                _FinishedBetsTab(),
                _WonBetsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OngoingBetsTab extends ConsumerWidget {
  const _OngoingBetsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betsAsync = ref.watch(ongoingBetsProvider);
    
    return betsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Erreur de chargement: $error',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      data: (bets) {
        if (bets.isEmpty) {
          return const _EmptyBetsTab(message: 'Aucun pari en cours');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: bets.length,
          itemBuilder: (context, index) {
            final bet = bets[index];
            if (bet.type == 'single') {
              return _SimpleBetCard(
                bet: _convertBetToMap(bet),
                statusColor: Colors.orange,
                showResult: false,
              );
            } else {
              return _CombineBetCard(
                bet: _convertCombineBetToMap(bet),
                statusColor: Colors.orange,
                showResult: false,
              );
            }
          },
        );
      },
    );
  }
}

class _FinishedBetsTab extends ConsumerWidget {
  const _FinishedBetsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betsAsync = ref.watch(finishedBetsProvider);
    
    return betsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Erreur de chargement: $error',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      data: (bets) {
        if (bets.isEmpty) {
          return const _EmptyBetsTab(message: 'Aucun pari terminé');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: bets.length,
          itemBuilder: (context, index) {
            final bet = bets[index];
            if (bet.type == 'single') {
              return _SimpleBetCard(
                bet: _convertBetToMap(bet),
                statusColor: bet.status == 'won' ? Colors.green : Colors.red,
                showResult: true,
              );
            } else {
              return _CombineBetCard(
                bet: _convertCombineBetToMap(bet),
                statusColor: Colors.red,
                showResult: true,
              );
            }
          },
        );
      },
    );
  }
}

class _WonBetsTab extends ConsumerWidget {
  const _WonBetsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betsAsync = ref.watch(wonBetsProvider);
    
    return betsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Erreur de chargement: $error',
          style: const TextStyle(color: Colors.white70),
        ),
      ),
      data: (bets) {
        if (bets.isEmpty) {
          return const _EmptyBetsTab(message: 'Aucun pari gagné');
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          itemCount: bets.length,
          itemBuilder: (context, index) {
            final bet = bets[index];
            return _SimpleBetCard(
              bet: _convertBetToMap(bet),
              statusColor: Colors.green,
              showResult: true,
            );
          },
        );
      },
    );
  }
}

// Helper function to convert Bet to Map for _SimpleBetCard
Map<String, dynamic> _convertBetToMap(Bet bet) {
  // Get the first selection for single bets
  final selection = bet.selections.isNotEmpty ? bet.selections.first : null;
  
  // Format match date if available
  String? matchDate;
  if (selection?.date != null && selection!.date!.isNotEmpty) {
    // If date is already formatted, use it directly
    matchDate = selection.date;
  }
  
  return {
    'id': bet.id.toString(),
    'type': bet.type,
    'game': selection?.gameName ?? '',
    'competition': selection?.competitionName ?? '',
    'betType': selection?.marketName ?? '',
    'selection': selection?.selectionName ?? '',
    'stake': bet.stake,
    'odds': selection?.oddAtPlacement ?? bet.totalOdd,
    'potentialWin': bet.potentialReturn,
    'status': _translateStatus(bet.status),
    'result': bet.result,
    'winAmount': bet.winAmount,
    'sport': _getSportCode(selection?.sportName),
    'sportIcon': selection?.sportIcon,
    'score': selection?.gameScore,
    'opponent1Name': selection?.opponent1Name,
    'opponent2Name': selection?.opponent2Name,
    'date': matchDate ?? bet.formattedDate,
    'matchTime': bet.formattedDate,
  };
}

// Helper function to convert Bet to Map for _CombineBetCard
Map<String, dynamic> _convertCombineBetToMap(Bet bet) {
  final map = <String, dynamic>{
    'id': bet.id.toString(),
    'type': 'combine',
    'selections': bet.selections.length,
    'stake': bet.stake,
    'totalOdds': bet.totalOdd,
    'potentialWin': bet.potentialReturn,
    'status': _translateStatus(bet.status),
    'result': bet.result,
    'matchTime': bet.formattedDate,
    'individualBets': <Map<String, dynamic>>[],
  };
  
  // Add individual selections
  for (var selection in bet.selections) {
    // Use the date field that's already available
    String? matchDate = selection.date;
    
    map['individualBets'].add({
      'player': selection.team ?? selection.selectionName,
      'status': _translateSelectionStatus(selection.status),
      'betType': selection.marketName ?? '',
      'odds': selection.oddAtPlacement,
      'date': matchDate ?? '',
      'score': selection.gameScore ?? '',
      'opponent1Name': selection.opponent1Name,
      'opponent2Name': selection.opponent2Name,
      'sport': _getSportCode(selection.sportName),
      'sportIcon': selection.sportIcon,
    });
  }
  
  return map;
}

// Helper function to translate status from API to UI
String _translateStatus(String status) {
  switch (status) {
    case 'ongoing': return 'En cours';
    case 'won': return 'Gagné';
    case 'lost': return 'Perdu';
    case 'cancelled': return 'Annulé';
    default: return status;
  }
}

// Helper function to translate selection status
String _translateSelectionStatus(String status) {
  switch (status) {
    case 'pending': return 'en_cours';
    case 'ongoing': return 'en_cours';
    case 'won': return 'gagné';
    case 'lost': return 'perdu';
    case 'cancelled': return 'annulé';
    default: return status;
  }
}

// Helper function to get sport code
String _getSportCode(String? sportName) {
  if (sportName == null) return 'unknown';
  
  switch (sportName.toLowerCase()) {
    case 'rocket league': return 'rocket_league';
    case 'football': return 'football';
    case 'tennis': return 'tennis';
    case 'basketball': return 'basketball';
    default: return sportName.toLowerCase().replaceAll(' ', '_');
  }
}

class _SimpleBetCard extends StatelessWidget {
  final Map<String, dynamic> bet;
  final Color statusColor;
  final bool showResult;

  const _SimpleBetCard({
    required this.bet,
    required this.statusColor,
    required this.showResult,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF222327),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              
              children: [
                Text(
                  'Simple',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bet['status'],
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Sport icon and player/team
            Row(
              children: [
                _getSportIconFromApi(bet['sportIcon']),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bet['selection'] ?? bet['game'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        bet['betType'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    bet['odds'].toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            // Match date and score for finished/won bets
            if (showResult && bet['score'] != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Match date
                    if (bet['date'] != null) ...[
                      Center(
                        child: Text(
                          bet['date'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    // Match score
                    Center(
                      child: Text(
                        '${bet['opponent1Name'] ?? ''} ${bet['score']} ${bet['opponent2Name'] ?? ''}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            

            
            if (!showResult) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        bet['opponent1Name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                                         Text(
                       _formatMatchTime(bet['date']),
                       style: const TextStyle(
                         color: Colors.white,
                         fontSize: 12,
                       ),
                     ),
                    Expanded(
                      child: Text(
                        bet['opponent2Name'] ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Financial info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Mise row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mise:',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${bet['stake']} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset('assets/icons/coin.png', height: 16),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Récompense row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getRewardLabel(bet['status']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${_getRewardValue(bet)} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Image.asset('assets/icons/coin.png', height: 18),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Reference and time
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Réf ${bet['id']}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CombineBetCard extends StatefulWidget {
  final Map<String, dynamic> bet;
  final Color statusColor;
  final bool showResult;

  const _CombineBetCard({
    required this.bet,
    required this.statusColor,
    required this.showResult,
  });

  @override
  State<_CombineBetCard> createState() => _CombineBetCardState();
}

class _CombineBetCardState extends State<_CombineBetCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final individualBets = widget.bet['individualBets'] as List;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF222327),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.statusColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Combiné (${widget.bet['selections']})',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.bet['status'],
                    style: TextStyle(
                      color: widget.statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            
            // Outcome indicators with arrow
            Row(
              children: [
                // Outcome circles
                ...individualBets.map((bet) => _getOutcomeIndicator(bet['status'])),
                const SizedBox(width: 8),
                // Expand/collapse arrow
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
            
            // Expanded individual bets
            if (_isExpanded) ...[
              const SizedBox(height: 16),
              ...individualBets.map((bet) => _IndividualBetItem(bet: bet)),
            ],
            
            const SizedBox(height: 16),
            
                        // Financial info
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cote totale
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cote totale:',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withOpacity(1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.bet['totalOdds'].toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Mise row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mise:',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${widget.bet['stake']} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset('assets/icons/coin.png', height: 16),
                      ],
                    ),
                  ],
                ),
                
                const SizedBox(height: 8),
                
                // Récompense row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getRewardLabel(widget.bet['status']),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${_getRewardValue(widget.bet)} ',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Image.asset('assets/icons/coin.png', height: 18),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Reference and time
            const SizedBox(height: 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Réf ${widget.bet['id']}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IndividualBetItem extends StatelessWidget {
  final Map<String, dynamic> bet;

  const _IndividualBetItem({required this.bet});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _getSportIconFromApi(bet['sportIcon']),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bet['player'] ?? bet['team'] ?? 'Unknown',
                      style: TextStyle(
                        color: bet['status'] == 'annulé' ? Colors.grey : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      bet['betType'],
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bet['odds'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          // Match info
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    bet['opponent1Name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  _formatMatchTime(bet['date']),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
                Expanded(
                  child: Text(
                    bet['opponent2Name'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _getSportIconFromApi(String? sportIcon) {
  if (sportIcon == null || sportIcon.isEmpty) {
    return const SizedBox.shrink();
  }
  
  return Container(
    width: 24,
    height: 24,
    decoration: BoxDecoration(
      color: Colors.transparent,
      shape: BoxShape.circle,
    ),
    child: ClipOval(
      child: sportIcon.startsWith('http') 
        ? Image.network(
            sportIcon,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          )
        : Image.asset(
            sportIcon,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
    ),
  );
}

Widget _getOutcomeIndicator(String status) {
  Color color;
  IconData icon;
  
  switch (status) {
    case 'gagné':
      color = Colors.green;
      icon = Icons.check;
      break;
    case 'perdu':
      color = Colors.red;
      icon = Icons.close;
      break;
    case 'annulé':
      color = Colors.grey;
      icon = Icons.remove;
      break;
    case 'en_cours':
      color = Colors.orange;
      icon = Icons.schedule;
      break;
    default:
      color = Colors.grey;
      icon = Icons.help_outline;
  }
  
  return Container(
    margin: const EdgeInsets.only(right: 4),
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: color.withOpacity(0.2),
      border: Border.all(color: color, width: 1),
      shape: BoxShape.circle,
    ),
    child: Icon(
      icon,
      color: color,
      size: 12,
    ),
  );
}

// Helper function to format match time
String _formatMatchTime(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return 'TBD';
  }
  
  try {
    // Parse date in format dd/MM/yyyy HH:mm
    final parts = dateString.split(' ');
    if (parts.length >= 2) {
      final datePart = parts[0]; // dd/MM/yyyy
      final timePart = parts[1]; // HH:mm
      
      // Parse the date
      final dateParts = datePart.split('/');
      if (dateParts.length == 3) {
        final day = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final year = int.parse(dateParts[2]);
        
        final matchDate = DateTime(year, month, day);
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final tomorrow = today.add(const Duration(days: 1));
        
        if (matchDate.isAtSameMomentAs(today)) {
          return 'Aujourd\'hui $timePart';
        } else if (matchDate.isAtSameMomentAs(tomorrow)) {
          return 'Demain $timePart';
        } else {
          // Format as dd/MM HH:mm for other dates
          return '${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')} $timePart';
        }
      }
    }
  } catch (e) {
    // If parsing fails, return the original string
    return dateString;
  }
  
  return dateString;
}

// Helper function to get reward label based on status
String _getRewardLabel(String status) {
  switch (status) {
    case 'En cours':
      return 'Récompense possible:';
    case 'Perdu':
      return 'Récompense:';
    case 'Gagné':
      return 'Récompense:';
    default:
      return 'Récompense possible:';
  }
}

// Helper function to get reward value based on status
String _getRewardValue(Map<String, dynamic> bet) {
  final status = bet['status'];
  
  switch (status) {
    case 'En cours':
      return bet['potentialWin']?.toString() ?? '0';
    case 'Perdu':
      return '0';
    case 'Gagné':
      return bet['winAmount']?.toString() ?? bet['potentialWin']?.toString() ?? '0';
    default:
      return bet['potentialWin']?.toString() ?? '0';
  }
}

class _EmptyBetsTab extends StatelessWidget {
  final String message;
  const _EmptyBetsTab({required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF222327),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.bookmarks_outlined,
              size: 64,
              color: Colors.grey.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Vos paris apparaîtront ici',
              style: TextStyle(
                color: Colors.grey.withOpacity(0.7),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}