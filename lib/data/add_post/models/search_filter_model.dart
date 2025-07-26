import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';
import 'dart:math';

class SearchFilter {
  final String? query;
  final String? brand;
  final String? model;
  final List<String>? fuelTypes;
  final List<String>? transmissionTypes;
  final int? minYear;
  final int? maxYear;
  final List<int>? ownerCounts;
  final double? minPrice;
  final double? maxPrice;
  final double? maxDistanceInKm;
  final LocationModel? userLocation;
  final String? sortBy;

  SearchFilter({
    this.query,
    this.brand,
    this.model,
    this.fuelTypes,
    this.transmissionTypes,
    this.minYear,
    this.maxYear,
    this.ownerCounts,
    this.minPrice,
    this.maxPrice,
    this.maxDistanceInKm,
    this.userLocation,
    this.sortBy,
  });

  SearchFilter copyWith({
    String? query,
    String? brand,
    String? model,
    List<String>? fuelTypes,
    List<String>? transmissionTypes,
    int? minYear,
    int? maxYear,
    List<int>? ownerCounts,
    double? minPrice,
    double? maxPrice,
    double? maxDistanceInKm,
    LocationModel? userLocation,
    String? sortBy,
  }) {
    return SearchFilter(
      query: query ?? this.query,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      fuelTypes: fuelTypes ?? this.fuelTypes,
      transmissionTypes: transmissionTypes ?? this.transmissionTypes,
      minYear: minYear ?? this.minYear,
      maxYear: maxYear ?? this.maxYear,
      ownerCounts: ownerCounts ?? this.ownerCounts,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      maxDistanceInKm: maxDistanceInKm ?? this.maxDistanceInKm,
      userLocation: userLocation ?? this.userLocation,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get isEmpty {
    return query == null &&
        brand == null &&
        model == null &&
        (fuelTypes == null || fuelTypes!.isEmpty) &&
        (transmissionTypes == null || transmissionTypes!.isEmpty) &&
        minYear == null &&
        maxYear == null &&
        (ownerCounts == null || ownerCounts!.isEmpty) &&
        minPrice == null &&
        maxPrice == null &&
        maxDistanceInKm == null &&
        userLocation == null &&
        sortBy == null;
  }
}

class SearchUtils {
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadius = 6371.0; // in kilometers

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  static List<AdWithUserModel> filterAndSortAds({
    required List<AdWithUserModel> ads,
    required SearchFilter filter,
  }) {
    var filteredAds = ads.where((adWithUser) {
      final ad = adWithUser.ad;

      // Handle query search (brand, model, year combined)
      if (filter.query != null && filter.query!.isNotEmpty) {
        final query = filter.query!.toLowerCase();
        final brandMatch = ad.brand.toLowerCase().contains(query);
        final modelMatch = ad.model.toLowerCase().contains(query);
        final yearMatch = ad.year.toString().contains(query);

        if (!brandMatch && !modelMatch && !yearMatch) {
          return false;
        }
      }

      // Individual filters
      if (filter.brand != null &&
          ad.brand.toLowerCase() != filter.brand!.toLowerCase()) {
        return false;
      }

      if (filter.model != null &&
          ad.model.toLowerCase() != filter.model!.toLowerCase()) {
        return false;
      }

      if (filter.fuelTypes != null &&
          filter.fuelTypes!.isNotEmpty &&
          !filter.fuelTypes!.any((type) => type.toLowerCase() == ad.fuelType.toLowerCase())) {
        return false;
      }

      if (filter.transmissionTypes != null &&
          filter.transmissionTypes!.isNotEmpty &&
          !filter.transmissionTypes!.any((type) => type.toLowerCase() == ad.transmissionType.toLowerCase())) {
        return false;
      }

      if (filter.minYear != null && ad.year < filter.minYear!) {
        return false;
      }

      if (filter.maxYear != null && ad.year > filter.maxYear!) {
        return false;
      }

      if (filter.ownerCounts != null &&
          filter.ownerCounts!.isNotEmpty &&
          !filter.ownerCounts!.contains(ad.noOfOwners)) {
        return false;
      }

      if (filter.minPrice != null && ad.price < filter.minPrice!) {
        return false;
      }

      if (filter.maxPrice != null && ad.price > filter.maxPrice!) {
        return false;
      }

      // Distance calculation
      if (filter.maxDistanceInKm != null && filter.userLocation != null) {
        try {
          final double distance = calculateDistance(
            filter.userLocation!.latitude,
            filter.userLocation!.longitude,
            ad.location.latitude,
            ad.location.longitude,
          );

          if (distance > filter.maxDistanceInKm!) {
            return false;
          }
        } catch (e) {
          print('Error calculating distance: $e');
          return false;
        }
      }

      return true;
    }).toList();

    // Then sort if needed
    if (filter.sortBy != null) {
      filteredAds.sort((a, b) {
        switch (filter.sortBy) {
          case 'price_asc':
            return a.ad.price.compareTo(b.ad.price);
          case 'price_desc':
            return b.ad.price.compareTo(a.ad.price);
          case 'year_asc':
            return a.ad.year.compareTo(b.ad.year);
          case 'year_desc':
            return b.ad.year.compareTo(a.ad.year);
          case 'distance_asc':
            if (filter.userLocation == null) return 0;
            try {
              final distanceA = calculateDistance(
                filter.userLocation!.latitude,
                filter.userLocation!.longitude,
                a.ad.location.latitude,
                a.ad.location.longitude,
              );
              final distanceB = calculateDistance(
                filter.userLocation!.latitude,
                filter.userLocation!.longitude,
                b.ad.location.latitude,
                b.ad.location.longitude,
              );
              return distanceA.compareTo(distanceB);
            } catch (e) {
              return 0;
            }
          default:
            return 0;
        }
      });
    } else {
      // Default sort order: newest posted first
      filteredAds.sort((a, b) => b.ad.postedDate.compareTo(a.ad.postedDate));
    }

    return filteredAds;
  }
}