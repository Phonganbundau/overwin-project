import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/esports/providers/competitions_notifier.dart';
import 'package:overwin_mobile/modules/esports/providers/esports_notifier.dart';
import 'package:overwin_mobile/modules/bets/providers/games.notifier.dart';

class SplashService {
  static Future<void> preloadData(WidgetRef ref, BuildContext context) async {
    try {
      // Preload esports data
      await ref.read(esportsProvider.future);
      
      // Preload competitions data
      await ref.read(competitionsProvider.future);
      
      // Preload games data
      await ref.read(gamesProvider.future);
      
      // Preload images (cache them)
      await _preloadImages(context);
      
      // Add a minimum delay to ensure smooth UX
      await Future.delayed(const Duration(milliseconds: 500));
      
    } catch (e) {
      // Log error but don't block the app
      debugPrint('Error preloading data: $e');
    }
  }

  static Future<void> _preloadImages(BuildContext context) async {
    try {
      // Preload common images
      const imagePaths = [
        'assets/icons/overwin.png',
        'assets/icons/coin.png',
        // Add more image paths as needed
      ];

      for (final path in imagePaths) {
        try {
          await precacheImage(AssetImage(path), context);
        } catch (e) {
          debugPrint('Error preloading image $path: $e');
        }
      }
    } catch (e) {
      debugPrint('Error in image preloading: $e');
    }
  }
}
