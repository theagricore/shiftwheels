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
  final bool isSold;
  final DateTime? soldDate;
  final List<String> favoritedByUsers;
  final List<String> interestedUsers;
  final List<String> chatIds;
  final String? geohash;

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
    this.isSold = false,
    this.soldDate,
    this.favoritedByUsers = const [],
    this.interestedUsers = const [],
    this.chatIds = const [],
    this.geohash,
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
    bool? isSold,
    DateTime? soldDate,
    List<String>? favoritedByUsers,
    List<String>? interestedUsers,
    List<String>? chatIds,
    String? geohash,
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
      isSold: isSold ?? this.isSold,
      soldDate: soldDate ?? this.soldDate,
      favoritedByUsers: favoritedByUsers ?? this.favoritedByUsers,
      interestedUsers: interestedUsers ?? this.interestedUsers,
      chatIds: chatIds ?? this.chatIds,
      geohash: geohash ?? this.geohash,
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
      isSold: map['isSold'] as bool? ?? false,
      soldDate: map['soldDate']?.toDate(),
      favoritedByUsers: List<String>.from(map['favoritedByUsers'] as List? ?? []),
      interestedUsers: List<String>.from(map['interestedUsers'] as List? ?? []),
      chatIds: List<String>.from(map['chatIds'] as List? ?? []),
      geohash: map['geohash'] as String?,
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
      'isSold': isSold,
      'soldDate': soldDate,
      'favoritedByUsers': favoritedByUsers,
      'interestedUsers': interestedUsers,
      'chatIds': chatIds,
      'geohash': geohash,
    };
  }

  @override
  String toString() {
    return 'AdsModel(id: $id, userId: $userId, brand: $brand, model: $model, fuelType: $fuelType, '
        'transmissionType: $transmissionType, year: $year, kmDriven: $kmDriven, '
        'noOfOwners: $noOfOwners, description: $description, location: $location, '
        'imageUrls: $imageUrls, price: $price, postedDate: $postedDate, '
        'isActive: $isActive, isSold: $isSold, soldDate: $soldDate, '
        'favoritedByUsers: $favoritedByUsers, interestedUsers: $interestedUsers, '
        'chatIds: $chatIds, geohash: $geohash)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is AdsModel &&
      other.id == id &&
      other.userId == userId &&
      other.brand == brand &&
      other.model == model &&
      other.fuelType == fuelType &&
      other.transmissionType == transmissionType &&
      other.year == year &&
      other.kmDriven == kmDriven &&
      other.noOfOwners == noOfOwners &&
      other.description == description &&
      other.location == location &&
      other.imageUrls == imageUrls &&
      other.price == price &&
      other.postedDate == postedDate &&
      other.isActive == isActive &&
      other.isSold == isSold &&
      other.soldDate == soldDate &&
      other.favoritedByUsers == favoritedByUsers &&
      other.interestedUsers == interestedUsers &&
      other.chatIds == chatIds &&
      other.geohash == geohash;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      brand.hashCode ^
      model.hashCode ^
      fuelType.hashCode ^
      transmissionType.hashCode ^
      year.hashCode ^
      kmDriven.hashCode ^
      noOfOwners.hashCode ^
      description.hashCode ^
      location.hashCode ^
      imageUrls.hashCode ^
      price.hashCode ^
      postedDate.hashCode ^
      isActive.hashCode ^
      isSold.hashCode ^
      soldDate.hashCode ^
      favoritedByUsers.hashCode ^
      interestedUsers.hashCode ^
      chatIds.hashCode ^
      geohash.hashCode;
  }
}