import 'package:overwin_mobile/modules/bets/models/opponent.dart';

class SelectedOutcome {
  final int outcomeId;
  final int gameId;
  final String esportIcon;
  final List<Opponent> opponents;
  final String outcomeName;
  final double outcomeOdd;
  final String betTypeName;

  SelectedOutcome({
    required this.outcomeId,
    required this.gameId,
    required this.esportIcon,
    required this.opponents,
    required this.outcomeName,
    required this.outcomeOdd,
    required this.betTypeName,
  });
} 