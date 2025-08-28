import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_app_bar.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_fab/custom_fab.dart';
import 'package:overwin_mobile/app/layout/widgets/custom_nav_bar.dart';
import 'package:overwin_mobile/modules/bets/views/bets_screen.dart';
import 'package:overwin_mobile/modules/challenges/views/challenges_screen.dart';
import 'package:overwin_mobile/modules/esports/views/top_competitions_top_esports_screen.dart';
import 'package:overwin_mobile/modules/my_bets/views/my_bets_screen.dart';
import 'package:overwin_mobile/modules/shop/views/shop_screen.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:overwin_mobile/modules/bets/providers/games.notifier.dart';
import 'package:overwin_mobile/modules/auth/providers/auth_provider.dart';
import 'package:overwin_mobile/modules/my_bets/providers/bets_provider.dart';

class AppLayout extends ConsumerWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  static const double _sidesPadding = 10.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();

    final tabRoutes = [
      '/esports',
      '/defis',
      '/paris',
      '/mes-paris',
      '/boutique',
    ];

    final isMainTab = tabRoutes.contains(location);
    final selectedIndex = _getIndexFromLocation(location);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: _sidesPadding),
          child: CustomAppBar(
            showBackButton: !isMainTab,
            onBackTap: () => context.pop(),
          ),
        ),
      ),
      floatingActionButton: CustomFab(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: _sidesPadding),
        child: isMainTab
            ? _TabIndexedStack(selectedIndex: selectedIndex)
            : child,
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: selectedIndex,
        onTap: (newIndex) {
          // Kiểm tra nếu nhấn vào tab Mes Paris (index 3)
          if (newIndex == 3) {
            final isLoggedIn = ref.read(isLoggedInProvider);
            if (!isLoggedIn) {
              // Nếu chưa đăng nhập, không chuyển hướng
              return;
            }
          }
          // Chuyển hướng đến tab được chọn
          context.go(tabRoutes[newIndex]);
        },
        onParisTabTap: () {
          // Refresh games data khi nhấn vào tab Paris
          ref.read(gamesProvider.notifier).refresh();
        },
        onMesParisTabTap: () {
          // Kiểm tra trạng thái đăng nhập
          final isLoggedIn = ref.read(isLoggedInProvider);
          if (!isLoggedIn) {
            // Nếu chưa đăng nhập, chuyển hướng đến trang đăng nhập
            context.go('/signin');
            // Hiển thị thông báo
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Veuillez vous connecter pour accéder à vos paris'),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
    
            Future.delayed(const Duration(milliseconds: 100), () {
              // Refresh ongoing bets (tab "En cours")
              ref.read(refreshBetsProvider.notifier).refreshOngoingBets();
            });
          }
        },
      ),
    );
  }

  int _getIndexFromLocation(String location) {
    if (location.startsWith('/esports')) return 0;
    if (location.startsWith('/defis')) return 1;
    if (location.startsWith('/paris')) return 2;
    if (location.startsWith('/mes-paris')) return 3;
    if (location.startsWith('/boutique')) return 4;
    return 0;
  }
}

class _TabIndexedStack extends StatefulWidget {
  final int selectedIndex;
  const _TabIndexedStack({required this.selectedIndex});

  @override
  State<_TabIndexedStack> createState() => _TabIndexedStackState();
}

class _TabIndexedStackState extends State<_TabIndexedStack> {
  late int _currentIndex;

  final List<Widget> _pages = const [
    TopCompetitionsTopESportsScreen(),
    ChallengesScreen(),
    BetsScreen(),
    MyBetsScreen(),
    ShopScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  @override
  void didUpdateWidget(covariant _TabIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      setState(() {
        _currentIndex = widget.selectedIndex;
      });
      

    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: _pages,
    );
  }
}
