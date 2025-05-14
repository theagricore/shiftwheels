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

  @override
  String toString() {
    return 'LocationModel(latitude: $latitude, longitude: $longitude, placeName: $placeName, address: $address, city: $city, country: $country)';
  }
}
