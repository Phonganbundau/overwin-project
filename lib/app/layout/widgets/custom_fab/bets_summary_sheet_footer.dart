import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/modules/bets/services/bet_service.dart';
import 'package:overwin_mobile/modules/auth/providers/auth_provider.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/theme/app_spacing.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/total_odds_provider.dart';
import 'package:overwin_mobile/shared/widgets/game_list/providers/selected_outcomes_provider.dart';

class BetsSummarySheetFooter extends ConsumerStatefulWidget {
  const BetsSummarySheetFooter({super.key});

  @override
  ConsumerState<BetsSummarySheetFooter> createState() => _BetsSummarySheetFooterState();
}

class _BetsSummarySheetFooterState extends ConsumerState<BetsSummarySheetFooter> {
  String _stake = "";

  @override
  Widget build(BuildContext context) {
    final totalText = ref.watch(totalOddsProvider);
    final totalOdds = double.tryParse(totalText.replaceAll(',', '.')) ?? 0.0;
    final stake = double.tryParse(_stake.replaceAll(',', '.')) ?? 0.0;
    final possibleGain = (totalOdds > 0 && stake > 0) ? (totalOdds * stake) : 0.0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.surface, border: Border(top: BorderSide(
        color: Colors.white38 
      ))),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.paddingFromSidesAndBars),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 170,
                  padding: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.surfaceContainer,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: false,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    style: const TextStyle(
                      color: AppColors.surfaceText,
                      fontSize: 17,
                    ),
                    maxLength: 8,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Mise',
                      hintStyle: TextStyle(color: AppColors.surfaceBubble),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      counterText: '', // cache le compteur de caractères
                    ),
                    onChanged: (value) {
                      setState(() {
                        _stake = value;
                      });
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(7),
                    child: Text(
                      totalText,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: AppColors.tertiary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Gains possibles",
                  style: TextStyle(
                    color: AppColors.surfaceText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      possibleGain.toStringAsFixed(2).replaceAll('.', ','),
                      style: TextStyle(color: AppColors.tertiary, fontSize: 20),
                    ),
                    const SizedBox(
                      width: 4,
                    ), // espace entre le texte et l’icône
                    Image.asset(
                      'assets/icons/coin.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
              ],
            ),
       
            // if (ref.watch(selectedOutcomesProvider).length > 1)
            //   Builder(
            //     builder: (context) {
            //       final outcomes = ref.watch(selectedOutcomesProvider);
            //       final gameIds = outcomes.map((o) => o.gameId).toSet();
            //       final hasConflict = gameIds.length < outcomes.length;
                  
            //       if (hasConflict) {
            //         return Container(
            //           width: double.infinity,
            //           margin: const EdgeInsets.only(bottom: 10),
            //           padding: const EdgeInsets.all(12),
            //           decoration: BoxDecoration(
            //             color: Colors.red[900],
            //             borderRadius: BorderRadius.circular(8),
            //             border: Border.all(color: Colors.red[300]!),
            //           ),
            //           child: Row(
            //             children: [
            //               Icon(Icons.warning, color: Colors.white, size: 20),
            //               const SizedBox(width: 8),
            //               Expanded(
            //                 child: Text(
            //                   'Conflit détecté: Vous avez sélectionné les deux équipes du même match',
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 12,
            //                     fontWeight: FontWeight.w500,
            //                   ),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         );
            //       }
            //       return const SizedBox.shrink();
            //     },
            //   ),
            
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                // Kiểm tra trạng thái đăng nhập trước
                final isLoggedIn = ref.read(isLoggedInProvider);
                if (!isLoggedIn) {
                  // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
                  context.go('/signin');       
                  return;
                }
                
                if (_stake.isEmpty || double.tryParse(_stake.replaceAll(',', '.')) == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez entrer une mise valide')),
                  );
                  return;
                }
                
                final outcomes = ref.read(selectedOutcomesProvider);
                if (outcomes.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Veuillez sélectionner au moins un pari')),
                  );
                  return;
                }
                
                // Kiểm tra xem có 2 outcomes nào thuộc cùng một trận đấu không
                final gameIds = outcomes.map((o) => o.gameId).toSet();
                if (gameIds.length < outcomes.length) {
                  // Có ít nhất 2 outcomes thuộc cùng một trận đấu
                  // Hiển thị thông báo lỗi ở trên sheet
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: Colors.red[900],
                      title: const Text(
                        'Erreur de sélection',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'Vous ne pouvez pas parier sur les deux équipes du même match. Veuillez sélectionner une seule équipe par match.',
                        style: TextStyle(color: Colors.white),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            'OK',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                
                final stake = double.tryParse(_stake.replaceAll(',', '.')) ?? 0.0;
                final totalOdds = double.tryParse(ref.read(totalOddsProvider).replaceAll(',', '.')) ?? 0.0;
                
                // Afficher un indicateur de chargement
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const Center(child: CircularProgressIndicator()),
                );
                
                try {
                  final result = await BetService.placeBet(
                    stake: stake,
                    totalOdd: totalOdds,
                    selections: outcomes,
                    context: context,
                  );
                  
                  // Fermer le dialogue de chargement
                  Navigator.of(context).pop();
                  
                  if (result['success']) {
                    
                    if (result['newBalance'] != null) {
                      final newBalance = (result['newBalance'] as num).toDouble();
                      ref.read(authProvider.notifier).updateBalance(newBalance);
                    }
                    
                    // Réinitialiser les sélections
                    ref.read(selectedOutcomesProvider.notifier).state = [];
                    
                    // Fermer la feuille de paris
                    Navigator.of(context).pop();
                    
                    // Afficher un message de succès
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'])),
                    );
                  } else {
                    // Afficher un message d'erreur
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(result['message'])),
                    );
                  }
                } catch (e) {
                  // Fermer le dialogue de chargement
                  Navigator.of(context).pop();
                  
                  // Afficher un message d'erreur
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur: ${e.toString()}')),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Parier",
                    style: TextStyle(color: AppColors.tertiary, fontSize: 17, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
