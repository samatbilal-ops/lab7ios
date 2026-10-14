import 'package:flutter/material.dart';

import '../data/products_data.dart';
import '../models/product.dart';
import 'detail_screen.dart';
import 'favorites_tab.dart';
import 'feed_tab.dart';
import 'profile_tab.dart';

/// Lab 7: root screen with BottomNavigationBar (Feed / Favorites / Profile).
class RootScreen extends StatefulWidget {
  final String userName;
  const RootScreen({super.key, this.userName = 'Guest'});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  static const List<String> _titles = ['SoleStore', 'Favorites', 'Profile'];

  int _index = 0;
  int _cartCount = 0;
  final Set<String> _favoriteIds = {};

  void _toggleFavorite(String id) {
    setState(() {
      if (!_favoriteIds.remove(id)) _favoriteIds.add(id);
    });
  }

  void _addToCart(int qty) => setState(() => _cartCount += qty);

  // Navigator.push: send the complete Product object to DetailScreen.
  void _openDetail(Product product) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => DetailScreen(
          product: product,
          isFavorite: _favoriteIds.contains(product.id),
          onToggleFavorite: () => _toggleFavorite(product.id),
          onAddToCart: _addToCart,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites =
        kProducts.where((p) => _favoriteIds.contains(p.id)).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(_titles[_index]),
        actions: [
          IconButton(
            tooltip: 'Cart',
            onPressed: () {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('Cart: $_cartCount item(s)'),
                  behavior: SnackBarBehavior.floating,
                ));
            },
            icon: Badge(
              isLabelVisible: _cartCount > 0,
              label: Text('$_cartCount'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      // IndexedStack keeps every tab alive -> state is not lost when switching.
      body: IndexedStack(
        index: _index,
        children: [
          FeedTab(
            favoriteIds: _favoriteIds,
            onOpen: _openDetail,
            onToggleFavorite: _toggleFavorite,
          ),
          FavoritesTab(
            favorites: favorites,
            onOpen: _openDetail,
            onToggleFavorite: _toggleFavorite,
          ),
          ProfileTab(
            userName: widget.userName,
            favoritesCount: favorites.length,
            cartCount: _cartCount,
            // Navigator.pop -> back to the registration form
            onLogout: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: favorites.isNotEmpty,
              label: Text('${favorites.length}'),
              child: const Icon(Icons.favorite_border),
            ),
            activeIcon: Badge(
              isLabelVisible: favorites.isNotEmpty,
              label: Text('${favorites.length}'),
              child: const Icon(Icons.favorite),
            ),
            label: 'Favorites',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
