import '../models/product.dart';

const String _u = 'https://images.unsplash.com/';
const List<int> _sizes = [39, 40, 41, 42, 43, 44, 45];

const List<Product> kProducts = [
  Product(
    id: 'p1',
    name: 'AeroRun Pro Lightweight Running Sneakers вЂ“ Limited Edition',
    brand: 'AeroRun',
    category: 'Sport',
    price: 129.99,
    oldPrice: 169.99,
    rating: 4.5,
    reviews: 1284,
    tags: ['Sneakers', 'Running', 'Men', 'Lightweight', 'New Arrival', 'Sport'],
    sizes: _sizes,
    description:
        'Engineered for daily runs and city walks. Breathable mesh upper, '
        'responsive foam midsole and a durable rubber outsole keep every step '
        'comfortable. The padded collar locks your heel in place while the '
        'wide toe box lets your foot move naturally on long distances.',
    imageUrl: '${_u}photo-1542291026-7eec264c27ff?w=900',
  ),
  Product(
    id: 'p2',
    name: 'Urban Classic Low',
    brand: 'Streetline',
    category: 'Classic',
    price: 89.00,
    rating: 4.2,
    reviews: 640,
    tags: ['Lifestyle', 'Unisex', 'Leather', 'Casual'],
    sizes: _sizes,
    description:
        'A clean everyday sneaker with a premium leather upper and a '
        'cushioned insole. Pairs with jeans, chinos or shorts.',
    imageUrl: '${_u}photo-1549298916-b41d501d3772?w=900',
  ),
  Product(
    id: 'p3',
    name: 'Court King High',
    brand: 'Hoops',
    category: 'Sport',
    price: 149.50,
    oldPrice: 179.00,
    rating: 4.7,
    reviews: 932,
    tags: ['Basketball', 'High-top', 'Ankle support', 'Men'],
    sizes: _sizes,
    description:
        'High-top support with a grippy outsole for fast cuts and explosive '
        'jumps on indoor courts.',
    imageUrl: '${_u}photo-1460353581641-37baddab0fa2?w=900',
  ),
  Product(
    id: 'p4',
    name: 'FlexTrain Gym Trainer',
    brand: 'FlexFit',
    category: 'Sport',
    price: 99.99,
    rating: 4.0,
    reviews: 311,
    tags: ['Training', 'Gym', 'Stable', 'Women'],
    sizes: _sizes,
    description:
        'A stable flat base for lifting and a flexible forefoot for HIIT. '
        'Breathable knit keeps your feet cool during intense sessions.',
    imageUrl: '${_u}photo-1491553895911-0055eca6402d?w=900',
  ),
];


const List<String> kCategories = ['All', 'Sport', 'Classic', 'Casual'];
