class LocationModel {
  final double latitude;
  final double longitude;
  final String? placeName;
  final String? address;
  final String? city;
  final String? country;

  const LocationModel({
    required this.latitude,
    required this.longitude,
    this.placeName,
    this.address,
    this.city,
    this.country,
  });

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      placeName: map['placeName'] as String?,
      address: map['address'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'placeName': placeName,
      'address': address,
      'city': city,
      'country': country,
    };
  }

  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude, placeName: $placeName, address: $address, city: $city, country: $country)';
  }
}