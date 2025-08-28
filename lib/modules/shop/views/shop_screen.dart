import 'package:flutter/material.dart';
import 'package:overwin_mobile/shared/theme/app_colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
final rewards = [
  _Reward(
    title: 'Manette PS5',
    subtitle: 'Contrôle ton jeu avec précision',
    cost: 25000,
    imageUrl: 'https://product.hstatic.net/200000637319/product/86482_may_choi_game_sony_playstation_5_ps5_pro_1_5e07256c11174aa19a4dda98012b0db5_master.jpg',
  ),
  _Reward(
    title: 'Clavier mécanique gamer',
    subtitle: 'Performance et style pour tes matchs',
    cost: 15000,
    imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSpWU82wwD0NYr4Gw1ZtL6ury7aA8KwPY-ZMA&s',
  ),
  _Reward(
    title: 'Maillot officiel d’équipe',
    subtitle: 'Affiche les couleurs de ton équipe préférée',
    cost: 30000,
    imageUrl: 'https://www.weston.com.sg/cdn/shop/files/dssd_ef9096fc-7fd9-48c9-9e45-d6cc85a4b2be_1024x1024.jpg?v=1719804684',
  ),
  _Reward(
    title: 'Casque gaming',
    subtitle: 'Immersion totale dans tes parties',
    cost: 20000,
    imageUrl: 'https://www.surdiscount.com/63834-large_default/casque-gaming-sans-fil-micro-pour-ps5pcps4-spirit-of-gamer-xpert-h900.jpg',
  ),
  _Reward(
    title: 'Carte cadeau PlayStation',
    subtitle: 'Crédits pour tes jeux favoris',
    cost: 10000,
    imageUrl: 'https://product.hstatic.net/200000118207/product/079182dc218f48948ac93088bb025cd0_d15848e426db41b8b800bf0353499858_grande.jpg',
  ),
];



    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (_, index) {
        if (index == 0) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Boutique non disponible dans la version bêta. Vous pouvez prévisualiser les récompenses.',
                style: TextStyle(color: Colors.white70),
              ),
            ),
          );
        }

        final reward = rewards[index - 1];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: _RewardCard(reward: reward),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemCount: rewards.length + 1,
    );
  }
}

class _RewardCard extends StatelessWidget {
  final _Reward reward;
  const _RewardCard({required this.reward});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  reward.imageUrl,
                  fit: BoxFit.cover,
                  width: 72,
                  height: 72,
                  // Placeholder khi load hoặc lỗi
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: Icon(Icons.card_giftcard, color: Colors.white70, size: 32),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.card_giftcard, color: Colors.white70, size: 32),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reward.title,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    reward.subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icons/coin.png', height: 16),
                    const SizedBox(width: 4),
                    Text(
                      reward.cost.toString(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Indisponible dans la version bêta'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Échanger',
                      style: TextStyle(
                        color: AppColors.tertiary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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


class _Reward {
  final String title;
  final String subtitle;
  final int cost;
  final String imageUrl;
  
  _Reward({
    required this.title,
    required this.subtitle,
    required this.cost,
    required this.imageUrl,
  });
}
