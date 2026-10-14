class Product {
  final String id;
  final String name;
  final String brand;
  final String category;
  final double price;
  final double? oldPrice;
  final double rating;
  final int reviews;
  final List<String> tags;
  final List<int> sizes;
  final String description;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.tags,
    required this.sizes,
    required this.description,
    required this.imageUrl,
  });

  int? get discountPercent =>
      oldPrice == null ? null : (((oldPrice! - price) / oldPrice!) * 100).round();
}
