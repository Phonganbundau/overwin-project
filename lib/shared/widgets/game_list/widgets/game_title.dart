import 'package:flutter/material.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:overwin_mobile/shared/widgets/icon_circle.dart';

class GameTitle extends StatelessWidget {
  final String esportIcon;
  final String competitionIcon;
  final String competitionName;
  final String name;

  const GameTitle({
    super.key,
    required this.esportIcon,
    required this.competitionIcon,
    required this.competitionName,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 10),
      child: Row(
        children: [
          IconCircle(
            assetPath: esportIcon.isNotEmpty ? esportIcon : 'assets/icons/rocket-league-logo.png', 
            backgroundColor: AppColors.surfaceBubble, 
            size: 20
          ),
          IconCircle(
            assetPath: competitionIcon.isNotEmpty ? competitionIcon : 'assets/icons/rlcs.png', 
            backgroundColor: AppColors.surfaceBubble, 
            size: 20
          ),
          const SizedBox(width: 12),
          Text(
            '${competitionName.isNotEmpty ? competitionName : 'Competition'} - ${name.isNotEmpty ? name : 'Unknown Game'}', 
            style: TextStyle(
              color: AppColors.surfaceText,
              fontSize: 13
            ),
          ),
        ],
      ),
    );
  }
}
