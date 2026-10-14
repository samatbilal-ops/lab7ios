import 'package:flutter/material.dart';

import '../models/product.dart';

/// Lab 5 + Lab 7: adaptive product preview that receives a full Product.
/// - Small screens: image on top, details below.
/// - Wide screens (>= 700 px): image left, details right.
class DetailScreen extends StatefulWidget {
  final Product product;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final ValueChanged<int> onAddToCart;

  const DetailScreen({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onAddToCart,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late bool bookmarked = widget.isFavorite;
  int quantity = 1;
  int? selectedSize;
  bool descExpanded = false;

  Product get p => widget.product;

  void toggleBookmark() {
    setState(() => bookmarked = !bookmarked);
    widget.onToggleFavorite();
  }

  void addToCart() {
    if (selectedSize == null) {
      _showMessage('Please select a size first', isError: true);
      return;
    }
    widget.onAddToCart(quantity);
    _showMessage('Added $quantity × size $selectedSize to cart');
  }

  void _showMessage(String text, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar back arrow = Navigator.pop (added automatically)
      appBar: AppBar(title: const Text('Product Preview')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            return SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(child: _cover()),
                            Expanded(child: _details()),
                          ],
                        )
                      : Column(children: [_cover(), _details()]),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  // Stack: cover + discount badge + bookmark badge
  Widget _cover() {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            p.imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (c, child, progress) => progress == null
                ? child
                : const Center(child: CircularProgressIndicator()),
            errorBuilder: (c, e, s) => Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported, size: 64),
            ),
          ),
          if (p.discountPercent != null)
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '-${p.discountPercent}%',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                tooltip: 'Bookmark',
                onPressed: toggleBookmark,
                icon: Icon(
                  bookmarked ? Icons.bookmark : Icons.bookmark_border,
                  color: bookmarked ? Colors.deepOrange : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _details() {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: title (Expanded) + price
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  p.name,
                  style: theme.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${p.price.toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (p.oldPrice != null)
                    Text(
                      '\$${p.oldPrice!.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Row: stars + rating text
          Row(
            children: [
              for (int i = 0; i < 5; i++)
                Icon(
                  p.rating >= i + 1
                      ? Icons.star
                      : p.rating > i
                          ? Icons.star_half
                          : Icons.star_border,
                  color: Colors.amber,
                  size: 22,
                ),
              const SizedBox(width: 8),
              Flexible(child: Text('${p.rating} (${p.reviews} reviews)')),
            ],
          ),
          const SizedBox(height: 20),

          // Wrap: category badges
          Text('Categories', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in p.tags)
                Chip(label: Text(t), visualDensity: VisualDensity.compact),
            ],
          ),
          const SizedBox(height: 20),

          // Size selector
          Text('Select size', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in p.sizes)
                ChoiceChip(
                  label: Text('$s'),
                  selected: selectedSize == s,
                  onSelected: (_) => setState(() => selectedSize = s),
                ),
            ],
          ),
          const SizedBox(height: 20),

          // Expandable description
          Text('Description', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Text(
            p.description,
            maxLines: descExpanded ? null : 3,
            overflow:
                descExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          TextButton(
            onPressed: () => setState(() => descExpanded = !descExpanded),
            child: Text(descExpanded ? 'Show less' : 'Read more'),
          ),
          const SizedBox(height: 8),

          // In-body back button (Navigator.pop)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back to list'),
            ),
          ),
        ],
      ),
    );
  }

  // Sticky bottom bar: total + stepper + Expanded "Add to Cart"
  Widget _bottomBar() {
    final theme = Theme.of(context);
    return Material(
      elevation: 12,
      color: theme.colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Total'),
                  const Spacer(),
                  Text(
                    '\$${(p.price * quantity).toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton.outlined(
                    tooltip: 'Decrease',
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                  SizedBox(
                    width: 36,
                    child: Text(
                      '$quantity',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: 'Increase',
                    icon: const Icon(Icons.add),
                    onPressed: () => setState(() => quantity++),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: addToCart,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                      ),
                      icon: const Icon(Icons.shopping_cart_outlined),
                      label: const FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text('Add to Cart'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
