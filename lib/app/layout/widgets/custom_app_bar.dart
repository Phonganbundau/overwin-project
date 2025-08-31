import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:overwin_mobile/modules/auth/providers/auth_provider.dart';
import 'package:overwin_mobile/shared/theme/app_modal_bottom_sheet.dart';

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  static const double _appBarHeight = 49.0;
  static const double _containerPadding = 4.0;
  static const double _spacingBetweenElements = 4.0;
  static const double _logoHeight = 120.0;
  static const double _coinIconHeight = 20.0;
  static const double _accountIconSize = 20.0;
  static const double _containerBorderRadius = 20.0;
  static const double _accountContainerBorderRadius = 25.0;
  static const double _containerSpacing = 5.0;
  static const double _fontSize = 12.0;

  final bool showBackButton;
  final VoidCallback? onBackTap;

  const CustomAppBar({
    super.key,
    this.showBackButton = false,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoggedIn = ref.watch(isLoggedInProvider);
    final user = ref.watch(authProvider);

    return AppBar(
      surfaceTintColor: Colors.black,
      titleSpacing: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackTap ?? () => Navigator.of(context).pop(),
            )
          else
            Image.asset(
              'assets/icons/overwin.png',
              height: _logoHeight,
              fit: BoxFit.contain,
            ),

          const Spacer(),

          if (isLoggedIn && user != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: _containerPadding,
                vertical: _containerPadding,
              ),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(27, 27, 27, 1),
                borderRadius: BorderRadius.circular(_containerBorderRadius),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/coin.png',
                    height: _coinIconHeight,
                  ),
                  const SizedBox(width: _spacingBetweenElements),
                  Text(
                    user.balance.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: _fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: _spacingBetweenElements),
                ],
              ),
            ),
            const SizedBox(width: _containerSpacing),

            Padding(
              padding: const EdgeInsets.all(8.0), // Mở rộng vùng nhấn
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    sheetAnimationStyle: AnimationStyle(
                      duration: Duration(milliseconds: AppModalBottomSheet.bottomSheetDuration),
                    ),
                    builder: (_) => _AccountSheet(user: user),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(_containerPadding),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(27, 27, 27, 1),
                    borderRadius: BorderRadius.circular(_accountContainerBorderRadius),
                  ),
                  child: const Icon(
                    Icons.account_circle_outlined,
                    color: Colors.white,
                    size: _accountIconSize,
                  ),
                ),
              ),
            ),
          ] else ...[
            // Login button when not logged in
            GestureDetector(
              onTap: () => context.go('/signin'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1C67FF),
                  borderRadius: BorderRadius.circular(_containerBorderRadius),
                ),
                child: const Text(
                  'Se connecter',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(_appBarHeight);
}

class _AccountSheet extends ConsumerStatefulWidget {
  final User user;
  const _AccountSheet({required this.user});

  @override
  ConsumerState<_AccountSheet> createState() => _AccountSheetState();
}

class _AccountSheetState extends ConsumerState<_AccountSheet> {
  bool _showProfileDetails = false;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return FractionallySizedBox(
      widthFactor: 1.0,
      heightFactor: AppModalBottomSheet.modalBottomSheetHeightFactor,
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppModalBottomSheet.modalBottomSheetRadius),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            children: [
              // Header with close button and back button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Row(
                  children: [
                    if (_showProfileDetails)
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            _showProfileDetails = false;
                          });
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      )
                    else
                      const Spacer(),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _showProfileDetails ? _buildProfileDetails() : _buildMainMenu(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMainMenu() {
    return Column(
      children: [
        // Token display banner with share button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF141b2e),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // Username row (moved to top)
              Text(
                widget.user.username,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              
              // Token icon row
              Image.asset('assets/icons/coin.png', height: 40),
              const SizedBox(height: 12),
              
              // Token amount row
              Text(
                widget.user.balance.toString(),
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 20),
              
              // Share button with blue background
              GestureDetector(
                onTap: () {
                  // NULL action
                },
                child: Container(
                  width: 130,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1C67FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text(
                      'PARTAGER',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // En ce moment section
        _AccountSection(
          title: 'En ce moment',
          children: [
            _AccountTile(
              icon: Icons.local_offer,
              iconColor: Colors.yellow,
              title: 'Code Promo',
              subtitle: 'Entrez un code promo',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
            _AccountTile(
              icon: Icons.people,
              iconColor: Colors.yellow,
              title: 'Parrainer des amis',
              subtitle: 'Gagnez des tokens en parrainant',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Gérer mon compte section
        _AccountSection(
          title: 'Gérer mon compte',
          children: [
            _AccountTile(
              icon: Icons.person,
              iconColor: Colors.brown,
              title: 'Mon profil',
              subtitle: 'Modifier mes informations',
              onTap: () {
                setState(() {
                  _showProfileDetails = true;
                });
              },
            ),
            _AccountTile(
              icon: Icons.settings,
              iconColor: Colors.yellow,
              title: 'Préférences',
              subtitle: 'Paramètres de l\'application',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
            _AccountTile(
              icon: Icons.language,
              iconColor: Colors.blue,
              title: 'Langue',
              subtitle: 'Français',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Aide & infos légales section
        _AccountSection(
          title: 'Aide & infos légales',
          children: [
            _AccountTile(
              icon: Icons.help_center,
              iconColor: Colors.blue,
              title: 'Centre d\'aide',
              subtitle: 'Support et assistance',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
            _AccountTile(
              icon: Icons.question_answer,
              iconColor: Colors.green,
              title: 'FAQ',
              subtitle: 'Questions fréquemment posées',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
            _AccountTile(
              icon: Icons.description,
              iconColor: Colors.orange,
              title: 'Conditions d\'utilisation',
              subtitle: 'Lire les conditions',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
            _AccountTile(
              icon: Icons.privacy_tip,
              iconColor: Colors.purple,
              title: 'Politique de confidentialité',
              subtitle: 'Lire la politique',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
            _AccountTile(
              icon: Icons.support_agent,
              iconColor: Colors.teal,
              title: 'Support client',
              subtitle: 'Contacter notre équipe',
              onTap: () {
                Navigator.of(context).pop(); // Close bottom sheet first
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Indisponible dans la version bêta')),
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Logout button inside scrollable content
        _LogoutButton(),
      ],
    );
  }

  Widget _buildProfileDetails() {
    return Column(
      children: [
        // Mon identité section
        _AccountSection(
          title: 'Mon identité',
          children: [
            if (widget.user.firstName != null)
              _ProfileInfoTile(
                icon: Icons.person_outline,
                iconColor: Colors.blue,
                title: 'Prénom',
                value: widget.user.firstName!,
              ),
            if (widget.user.lastName != null)
              _ProfileInfoTile(
                icon: Icons.person_outline,
                iconColor: Colors.blue,
                title: 'Nom',
                value: widget.user.lastName!,
              ),
            _ProfileInfoTile(
              icon: Icons.cake,
              iconColor: Colors.pink,
              title: 'Date de naissance',
              value: '${widget.user.dateOfBirth.day}/${widget.user.dateOfBirth.month}/${widget.user.dateOfBirth.year}',
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Mes informations de contact section
        _AccountSection(
          title: 'Mes informations de contact',
          children: [
            if (widget.user.email != null)
              _ProfileInfoTile(
                icon: Icons.email,
                iconColor: Colors.green,
                title: 'Email',
                value: widget.user.email!,
              ),
            _ProfileInfoTile(
              icon: Icons.phone,
              iconColor: Colors.orange,
              title: 'Téléphone',
              value: widget.user.phoneNumber,
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Mon compte section
        _AccountSection(
          title: 'Mon compte',
          children: [
            _ProfileInfoTile(
              icon: Icons.account_circle,
              iconColor: Colors.purple,
              title: 'Pseudo',
              value: widget.user.username,
            ),
            _ProfileInfoTile(
              icon: Icons.calendar_today,
              iconColor: Colors.teal,
              title: 'Date de création du compte',
              value: '01/01/2024', // Placeholder 
            ),
          ],
        ),
        const SizedBox(height: 20),
        
        // Clôturer mon compte button
        Padding(
          padding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () {
              
            },
            child: Container(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Clôturer mon compte',
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class _AccountSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _AccountSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF222327),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AccountTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String? badge;
  final Color? badgeColor;
  final VoidCallback onTap;
  const _AccountTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.badge,
    this.badgeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor ?? Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black, 
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.grey, 
                    fontSize: 12,
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

class _LogoutButton extends ConsumerWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () async {
          await ref.read(authProvider.notifier).signOut();
          Navigator.of(context).pop(); // Close the bottom sheet
          context.go('/paris'); // Navigate to main screen
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Text(
              'Se déconnecter',
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
