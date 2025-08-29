import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/app/layout/app_layout.dart';
import 'package:overwin_mobile/modules/auth/views/sign_in_screen.dart';
import 'package:overwin_mobile/modules/auth/views/sign_up_screen.dart';
import 'package:overwin_mobile/modules/auth/views/email_verification_screen.dart';
import 'package:overwin_mobile/modules/esports/views/top_competitions_top_esports_screen.dart';
import 'package:overwin_mobile/modules/esports/views/esport_details_screen.dart';
import 'package:overwin_mobile/modules/esports/models/e_sport.dart';
import 'package:overwin_mobile/modules/esports/models/competition.dart';
import 'package:overwin_mobile/modules/esports/views/competition_details_screen.dart';
import 'package:overwin_mobile/modules/bets/views/game_details_screen.dart';
import 'package:overwin_mobile/modules/bets/models/game.dart';
import 'package:overwin_mobile/modules/profile/views/profile_screen.dart';

// clé pour le ShellNavigator (permet de push des routes tout en gardant AppBar + NavBar)
final _shellNavigatorKey = GlobalKey<NavigatorState>();

// Global navigator key for deep links
final globalNavigatorKey = GlobalKey<NavigatorState>();

/// Widget to show a modal bottom sheet after the build phase completes
class _DelayedModalLauncher extends StatefulWidget {
  final Function(BuildContext) builder;
  
  const _DelayedModalLauncher({required this.builder});

  @override
  State<_DelayedModalLauncher> createState() => _DelayedModalLauncherState();
}

class _DelayedModalLauncherState extends State<_DelayedModalLauncher> {
  @override
  void initState() {
    super.initState();
    // Schedule the bottom sheet to open after this frame completes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.builder(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Return a container that will be replaced by our router once the modal is closed
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.shrink(),
    );
  }
}

final GoRouter goRouter = GoRouter(
  initialLocation: '/paris',
  navigatorKey: globalNavigatorKey,
  routes: [
    /// Routes hors layout : pas d'AppBar/NavBar
    GoRoute(
      path: '/signin',
      builder: (context, state) {
        // We'll return a wrapper that will show the bottom sheet after the build is complete
        return _DelayedModalLauncher(
          builder: (context) => SignInScreen.show(context),
        );
      },
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) {
        // We'll return a wrapper that will show the bottom sheet after the build is complete
        return _DelayedModalLauncher(
          builder: (context) => SignUpScreen.show(context),
        );
      },
    ),
    GoRoute(
      path: '/verify-email',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'];
        return EmailVerificationScreen(token: token);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    /// ShellRoute avec AppBar + NavBar partagés
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppLayout(child: child,),
      routes: [
        /// Onglets principaux
        GoRoute(
          path: '/esports',
          builder: (context, state) => const TopCompetitionsTopESportsScreen(),
        ),
        GoRoute(
          path: '/defis',
          builder: (context, state) => const Center(child: Text('Défis')),
        ),
        GoRoute(
          path: '/paris',
          builder: (context, state) => const Center(child: Text('Paris')),
        ),
        GoRoute(
          path: '/mes-paris',
          builder: (context, state) => const Center(child: Text('Mes Paris')),
        ),
        GoRoute(
          path: '/boutique',
          builder: (context, state) => const Center(child: Text('Boutique')),
        ),

        /// Page de détail imbriquée : conserve AppBar + NavBar
        GoRoute(
          path: '/esport-details',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final esport = state.extra as ESport;
            return EsportDetailsScreen(esport: esport);
          },
        ),
        GoRoute(
          path: '/competition-details',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final competition = state.extra as Competition;
            return CompetitionDetailsScreen(competition: competition);
          },
        ),
        GoRoute(
          path: '/game-details',
          parentNavigatorKey: _shellNavigatorKey,
          builder: (context, state) {
            final game = state.extra as Game;
            return GameDetailsScreen(game: game);
          },
        ),
      ],
    ),
  ],
);