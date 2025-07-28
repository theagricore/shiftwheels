import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';

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

  bool get shouldFilterByDistance {
    return maxDistanceInKm != null && 
           maxDistanceInKm! > 0 && 
           userLocation != null;
  }

  @override
  String toString() {
    return 'SearchFilter('
        'query: $query, '
        'brand: $brand, '
        'model: $model, '
        'fuelTypes: $fuelTypes, '
        'transmissionTypes: $transmissionTypes, '
        'minYear: $minYear, '
        'maxYear: $maxYear, '
        'ownerCounts: $ownerCounts, '
        'minPrice: $minPrice, '
        'maxPrice: $maxPrice, '
        'maxDistanceInKm: $maxDistanceInKm, '
        'userLocation: $userLocation, '
        'sortBy: $sortBy)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SearchFilter &&
      other.query == query &&
      other.brand == brand &&
      other.model == model &&
      other.fuelTypes == fuelTypes &&
      other.transmissionTypes == transmissionTypes &&
      other.minYear == minYear &&
      other.maxYear == maxYear &&
      other.ownerCounts == ownerCounts &&
      other.minPrice == minPrice &&
      other.maxPrice == maxPrice &&
      other.maxDistanceInKm == maxDistanceInKm &&
      other.userLocation == userLocation &&
      other.sortBy == sortBy;
  }

  @override
  int get hashCode {
    return query.hashCode ^
      brand.hashCode ^
      model.hashCode ^
      fuelTypes.hashCode ^
      transmissionTypes.hashCode ^
      minYear.hashCode ^
      maxYear.hashCode ^
      ownerCounts.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      maxDistanceInKm.hashCode ^
      userLocation.hashCode ^
      sortBy.hashCode;
  }
}

class SearchUtils {
  static List<AdWithUserModel> filterAndSortAds({
    required List<AdWithUserModel> ads,
    required SearchFilter filter,
  }) {
    // Apply non-location filters
    List<AdWithUserModel> filteredAds = ads.where((ad) {
      // Query filter
      if (filter.query != null && filter.query!.isNotEmpty) {
        final query = filter.query!.toLowerCase();
        if (!ad.ad.brand.toLowerCase().contains(query) &&
            !ad.ad.model.toLowerCase().contains(query) &&
            !ad.ad.year.toString().contains(query)) {
          return false;
        }
      }

      // Basic filters
      if (filter.brand != null && ad.ad.brand != filter.brand) return false;
      if (filter.model != null && ad.ad.model != filter.model) return false;
      
      // Multi-select filters
      if (filter.fuelTypes != null && 
          filter.fuelTypes!.isNotEmpty &&
          !filter.fuelTypes!.contains(ad.ad.fuelType)) {
        return false;
      }
      
      if (filter.transmissionTypes != null && 
          filter.transmissionTypes!.isNotEmpty &&
          !filter.transmissionTypes!.contains(ad.ad.transmissionType)) {
        return false;
      }
      
      if (filter.ownerCounts != null && 
          filter.ownerCounts!.isNotEmpty &&
          !filter.ownerCounts!.contains(ad.ad.noOfOwners)) {
        return false;
      }

      // Range filters
      if (filter.minYear != null && ad.ad.year < filter.minYear!) return false;
      if (filter.maxYear != null && ad.ad.year > filter.maxYear!) return false;
      if (filter.minPrice != null && ad.ad.price < filter.minPrice!) return false;
      if (filter.maxPrice != null && ad.ad.price > filter.maxPrice!) return false;

      return true;
    }).toList();

    // Apply sorting
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
            return (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0);
          default:
            return 0;
        }
      });
    } else {
      // Default sort by newest first
      filteredAds.sort((a, b) => b.ad.postedDate.compareTo(a.ad.postedDate));
    }

    return filteredAds;
  }

  static String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return 'th';
    }
    switch (number % 10) {
      case 1: return 'st';
      case 2: return 'nd';
      case 3: return 'rd';
      default: return 'th';
    }
  }
}