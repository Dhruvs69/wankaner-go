// lib/features/customer/models/address_model.dart

class Address {
  final String id;
  final String userId;
  final String title;
  final String address;
  final double lat;
  final double lng;

  Address({
    required this.id,
    required this.userId,
    required this.title,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Address.fromMap(Map<String, dynamic> map, String documentId) {
    return Address(
      id: map['id'] ?? documentId,
      userId: map['user_id'] ?? '',
      title: map['title'] ?? 'Other',
      address: map['address'] ?? '',
      lat: (map['lat'] ?? 0.0).toDouble(),
      lng: (map['lng'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'address': address,
      'lat': lat,
      'lng': lng,
    };
  }
}
