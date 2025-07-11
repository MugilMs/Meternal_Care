class Hospital {
  final int id;
  final String name;
  final String address;
  final String phone;
  final String email;
  final String website;
  final List<String> services;
  final String imageUrl;
  final double rating;
  final double distance;
  final double latitude;
  final double longitude;

  Hospital({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.services,
    required this.imageUrl,
    required this.rating,
    required this.distance,
    required this.latitude,
    required this.longitude,
  });

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      email: json['email'],
      website: json['website'],
      services: List<String>.from(json['services']),
      imageUrl: json['imageUrl'],
      rating: json['rating'].toDouble(),
      distance: json['distance'].toDouble(),
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'services': services,
      'imageUrl': imageUrl,
      'rating': rating,
      'distance': distance,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
