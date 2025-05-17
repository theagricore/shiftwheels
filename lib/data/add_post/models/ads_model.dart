import 'package:shiftwheels/data/add_post/models/location_model.dart';

class AdsModel {
  final String? id;
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final int seatCount;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  final LocationModel location;
  final List<String> imageUrls;
  final double price;
  final DateTime postedDate;
  final bool isActive;
  final bool isFavorite;
  final List<String> chatIds;

  AdsModel({
    this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.seatCount,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
    required this.location,
    required this.imageUrls,
    required this.price,
    required this.postedDate,
    this.isActive = true,
    this.isFavorite = false,
    this.chatIds = const [],
  });

  bool isValid() {
    return userId.isNotEmpty &&
        brand.isNotEmpty &&
        model.isNotEmpty &&
        fuelType.isNotEmpty &&
        seatCount > 0 &&
        year > 1900 &&
        year <= DateTime.now().year &&
        kmDriven >= 0 &&
        noOfOwners >= 0 &&
        description.isNotEmpty &&
        imageUrls.isNotEmpty &&
        price > 0 &&
        location.latitude != 0 &&
        location.longitude != 0;
  }

  factory AdsModel.fromMap(Map<String, dynamic> map, String id) {
    return AdsModel(
      id: id,
      userId: map['userId'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      fuelType: map['fuelType'] as String,
      seatCount: map['seatCount'] as int,
      year: map['year'] as int,
      kmDriven: map['kmDriven'] as int,
      noOfOwners: map['noOfOwners'] as int,
      description: map['description'] as String,
      location: LocationModel.fromMap(map['location'] as Map<String, dynamic>),
      imageUrls: List<String>.from(map['imageUrls'] as List),
      price: map['price'] as double,
      postedDate: DateTime.parse(map['postedDate'] as String),
      isActive: map['isActive'] as bool? ?? true,
      isFavorite: map['isFavorite'] as bool? ?? false,
      chatIds: List<String>.from(map['chatIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'brand': brand,
      'model': model,
      'fuelType': fuelType,
      'seatCount': seatCount,
      'year': year,
      'kmDriven': kmDriven,
      'noOfOwners': noOfOwners,
      'description': description,
      'location': location.toMap(),
      'imageUrls': imageUrls,
      'price': price,
      'postedDate': postedDate.toIso8601String(),
      'isActive': isActive,
      'isFavorite': isFavorite,
      'chatIds': chatIds,
    };
  }
}
