import 'package:shiftwheels/data/add_post/models/location_model.dart';

class AdsModel {
  final String? id;
  final String userId;
  final String brand;
  final String model;
  final String fuelType;
  final String transmissionType;
  final int year;
  final int kmDriven;
  final int noOfOwners;
  final String description;
  final LocationModel location;
  final List<String> imageUrls;
  final double price;
  final DateTime postedDate;
  final bool isActive;
  final List<String> favoritedByUsers;
  final List<String> chatIds;  

  AdsModel({
    this.id,
    required this.userId,
    required this.brand,
    required this.model,
    required this.fuelType,
    required this.transmissionType,
    required this.year,
    required this.kmDriven,
    required this.noOfOwners,
    required this.description,
    required this.location,
    required this.imageUrls,
    required this.price,
    required this.postedDate,
    this.isActive = true,
    this.favoritedByUsers = const [],
    this.chatIds = const [],
  });

  AdsModel copyWith({
    String? id,
    String? userId,
    String? brand,
    String? model,
    String? fuelType,
    String? transmissionType,
    int? year,
    int? kmDriven,
    int? noOfOwners,
    String? description,
    LocationModel? location,
    List<String>? imageUrls,
    double? price,
    DateTime? postedDate,
    bool? isActive,
    List<String>? favoritedByUsers,
    List<String>? chatIds,
    bool? isFavorite,
  }) {
    return AdsModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      fuelType: fuelType ?? this.fuelType,
      transmissionType: transmissionType ?? this.transmissionType,
      year: year ?? this.year,
      kmDriven: kmDriven ?? this.kmDriven,
      noOfOwners: noOfOwners ?? this.noOfOwners,
      description: description ?? this.description,
      location: location ?? this.location,
      imageUrls: imageUrls ?? this.imageUrls,
      price: price ?? this.price,
      postedDate: postedDate ?? this.postedDate,
      isActive: isActive ?? this.isActive,
      favoritedByUsers: favoritedByUsers ?? this.favoritedByUsers,
      chatIds: chatIds ?? this.chatIds,
    );
  }

  factory AdsModel.fromMap(Map<String, dynamic> map, String id) {
    return AdsModel(
      id: id,
      userId: map['userId'] as String,
      brand: map['brand'] as String,
      model: map['model'] as String,
      fuelType: map['fuelType'] as String,
      transmissionType: map['transmissionType'] as String,
      year: map['year'] as int,
      kmDriven: map['kmDriven'] as int,
      noOfOwners: map['noOfOwners'] as int,
      description: map['description'] as String,
      location: LocationModel.fromMap(map['location'] as Map<String, dynamic>),
      imageUrls: List<String>.from(map['imageUrls'] as List),
      price: (map['price'] as num).toDouble(),
      postedDate: DateTime.parse(map['postedDate'] as String),
      isActive: map['isActive'] as bool? ?? true,
      favoritedByUsers: List<String>.from(
        map['favoritedByUsers'] as List? ?? [],
      ),
      chatIds: List<String>.from(map['chatIds'] as List? ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'brand': brand,
      'model': model,
      'fuelType': fuelType,
      'transmissionType': transmissionType,
      'year': year,
      'kmDriven': kmDriven,
      'noOfOwners': noOfOwners,
      'description': description,
      'location': location.toMap(),
      'imageUrls': imageUrls,
      'price': price,
      'postedDate': postedDate.toIso8601String(),
      'isActive': isActive,
      'favoritedByUsers': favoritedByUsers,
      'chatIds': chatIds,
    };
  }
}