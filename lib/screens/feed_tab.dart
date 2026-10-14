import 'package:flutter/material.dart';

import '../data/products_data.dart';
import '../models/product.dart';
import '../widgets/category_chips.dart';
import '../widgets/product_tile.dart';

enum SortOption { none, priceLow, priceHigh, rating }

/// Tab 1: product list with category filter and sorting.
class FeedTab extends StatefulWidget {
  final Set<String> favoriteIds;
  final ValueChanged<Product> onOpen;
  final ValueChanged<String> onToggleFavorite;

  const FeedTab({
    super.key,
    required this.favoriteIds,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  @override
  State<FeedTab> createState() => _FeedTabState();
}

class _FeedTabState extends State<FeedTab> {
  String _category = 'All';
  SortOption _sort = SortOption.none;

  static const Map<SortOption, String> _sortLabels = {
    SortOption.none: 'Default',
    SortOption.priceLow: 'Price: low to high',
    SortOption.priceHigh: 'Price: high to low',
    SortOption.rating: 'Top rated',
  };

  // Filter by category, then sort.
  List<Product> get _visible {
    final list = kProducts
        .where((p) => _category == 'All' || p.category == _category)
        .toList();
    switch (_sort) {
      case SortOption.priceLow:
        list.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceHigh:
        list.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.rating:
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case SortOption.none:
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = _visible;

    return Column(
      children: [
        const SizedBox(height: 8),
        CategoryChips(
          categories: kCategories,
          selected: _category,
          onSelected: (c) => setState(() => _category = c),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${items.length} sneakers',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuButton<SortOption>(
                tooltip: 'Sort',
                initialValue: _sort,
                onSelected: (s) => setState(() => _sort = s),
                itemBuilder: (context) => [
                  for (final e in _sortLabels.entries)
                    PopupMenuItem(value: e.key, child: Text(e.value)),
                ],
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort, size: 20),
                      const SizedBox(width: 4),
                      Text(_sortLabels[_sort]!),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: items.isEmpty
              ? const Center(child: Text('No sneakers in this category'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 8),
                  itemCount: items.length,
                  itemBuilder: (context, i) {
                    final p = items[i];
                    return ProductTile(
                      product: p,
                      isFavorite: widget.favoriteIds.contains(p.id),
                      onTap: () => widget.onOpen(p),
                      onFavorite: () => widget.onToggleFavorite(p.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
} 