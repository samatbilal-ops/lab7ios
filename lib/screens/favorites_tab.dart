import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_tile.dart';

/// Tab 2: saved products.
class FavoritesTab extends StatelessWidget {
  final List<Product> favorites;
  final ValueChanged<Product> onOpen;
  final ValueChanged<String> onToggleFavorite;

  const FavoritesTab({
    super.key,
    required this.favorites,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text('No favorites yet'),
            const SizedBox(height: 4),
            Text(
              'Tap the heart on any sneaker',
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: favorites.length,
      itemBuilder: (context, i) {
        final p = favorites[i];
        return ProductTile(
          product: p,
          isFavorite: true,
          onTap: () => onOpen(p),
          onFavorite: () => onToggleFavorite(p.id),
        );
      },
    );
  }
}
