// lib/features/customer/models/vendor_model.dart

class Vendor {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewCount;
  final double totalRatingScore;
  final bool isOpen;
  final bool isActive;
  final bool isPromoted;
  final String distance;
  final String imageUrl;
  final double lat;
  final double lng;
  final List<dynamic> items; // For searching products
  final String? ownerId;
  final double walletBalance;
  final String? openingTime;
  final String? closingTime;

  Vendor({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    this.reviewCount = 0,
    this.totalRatingScore = 0.0,
    required this.isOpen,
    this.isActive = true,
    this.isPromoted = false,
    required this.distance,
    required this.imageUrl,
    this.lat = 0.0,
    this.lng = 0.0,
    this.items = const [],
    this.ownerId,
    this.walletBalance = 0.0,
    this.openingTime,
    this.closingTime,
  });

  factory Vendor.fromMap(Map<String, dynamic> map, String documentId) {
    return Vendor(
      id: map['id'] ?? documentId,
      name: map['name'] ?? 'Unknown Shop',
      category: map['category'] ?? 'General',
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['review_count'] ?? map['reviewCount'] ?? 0,
      totalRatingScore: (map['total_rating_score'] ?? map['totalRatingScore'] ?? 0.0).toDouble(),
      isOpen: map['is_open'] == 1 || map['is_open'] == true || map['isOpen'] == true,
      isActive: map['is_active'] == null || map['is_active'] == 1 || map['is_active'] == true || map['isActive'] == true,
      isPromoted: map['is_promoted'] == 1 || map['is_promoted'] == true || map['isPromoted'] == true,
      distance: map['distance'] ?? '0.0 km',
      imageUrl: map['image_url'] ?? map['imageUrl'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
      items: map['items'] ?? [],
      ownerId: map['owner_id'] ?? map['ownerId'],
      walletBalance: (map['wallet_balance'] ?? map['walletBalance'] ?? 0.0).toDouble(),
      openingTime: map['opening_time'] ?? map['openingTime'],
      closingTime: map['closing_time'] ?? map['closingTime'],
    );
  }
}