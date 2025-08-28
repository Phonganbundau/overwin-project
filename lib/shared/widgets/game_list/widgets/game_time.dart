import 'package:flutter/material.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';

class GameTime extends StatelessWidget {
  final DateTime scheduledAt;
  const GameTime({super.key, required this.scheduledAt});

  @override
  Widget build(BuildContext context) {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final target = DateTime(
        scheduledAt.year,
        scheduledAt.month,
        scheduledAt.day,
      );
      final diff = target.difference(today).inDays;

      String dayLabel;
      if (diff == 0) {
        dayLabel = "Aujourd'hui";
      } else if (diff == 1) {
        dayLabel = "Demain";
      } else {
        final day = scheduledAt.day.toString().padLeft(2, '0');
        final month = scheduledAt.month.toString().padLeft(2, '0');
        dayLabel = "$day/$month";
      }

      final hour = scheduledAt.hour.toString().padLeft(2, '0');
      final minute = scheduledAt.minute.toString().padLeft(2, '0');
      final timeLabel = "$hour:$minute";

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(dayLabel, style: TextStyle(color: AppColors.surfaceText, height: 1.3, fontSize: 13)),
          Text(timeLabel, style: TextStyle(color: AppColors.surfaceText, height: 1.3, fontSize: 18)),
        ],
      );
    } catch (e) {
      print('Error in GameTime: $e');
      // Return default time display if there's an error
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Aujourd'hui", style: TextStyle(color: AppColors.surfaceText, height: 1.3, fontSize: 13)),
          Text("00:00", style: TextStyle(color: AppColors.surfaceText, height: 1.3, fontSize: 18)),
        ],
      );
    }
  }
}
