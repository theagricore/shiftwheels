import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';

abstract class FirebasePostService {
  Future<Either<String, List<BrandModel>>> getBrands();
  Future<Either<String, List<String>>> getModels(String brandId);
  Future<Either<String, List<FuelsModel>>> getFuel();
  Future<Either<String, LocationModel>> getCurrentLocation();
  Future<Either<String, List<LocationModel>>> searchLocation(String query);
  Future<Either<String, String>> postAd(AdsModel ad);
  Future<Either<String, List<AdWithUserModel>>> getActiveAdsWithUsers();
}

class PostFirebaseServiceImpl extends FirebasePostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final loc.Location _location = loc.Location();

  @override
  Future<Either<String, List<BrandModel>>> getBrands() async {
    try {
      final snapshot = await _firestore.collection('Brands').get();
      final brands =
          snapshot.docs.map((doc) {
            return BrandModel(
              id: doc.id,
              brandName: doc['brandName'] as String? ?? '',
              image: doc['image'] as String?,
            );
          }).toList();

      if (brands.isEmpty) {
        return Left('No brands found');
      }
      return Right(brands);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<String>>> getModels(String brandId) async {
    try {
      final snapshot =
          await _firestore
              .collection('Brands')
              .doc(brandId)
              .collection('Models')
              .get();

      final models =
          snapshot.docs
              .map((doc) => doc['modelName'] as String? ?? '')
              .where((name) => name.isNotEmpty)
              .toList();

      if (models.isEmpty) {
        return Left('No models found for this brand');
      }
      return Right(models);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<FuelsModel>>> getFuel() async {
    try {
      final snapshot = await _firestore.collection('fuels').get();
      final fuels =
          snapshot.docs.map((doc) {
            return FuelsModel(id: doc.id, fuels: doc['fuels'] as String? ?? '');
          }).toList();
      return Right(fuels);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, LocationModel>> getCurrentLocation() async {
    try {
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          return Left('Location services are disabled');
        }
      }

      loc.PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != loc.PermissionStatus.granted) {
          return Left('Location permissions are denied');
        }
      }

      final locationData = await _location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        return Left('Failed to get valid location coordinates');
      }

      final placeDetails = await _getPlaceDetails(
        locationData.latitude!,
        locationData.longitude!,
      );

      return Right(
        LocationModel(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          placeName: placeDetails['placeName'],
          address: placeDetails['address'],
          city: placeDetails['city'],
          country: placeDetails['country'],
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == 'SERVICE_STATUS_ERROR') {
        return Left('Location services are disabled');
      } else if (e.code == 'PERMISSION_DENIED') {
        return Left('Location permissions are denied');
      }
      return Left('Failed to get location: ${e.message}');
    } catch (e) {
      return Left('Failed to get location: ${e.toString()}');
    }
  }

  Future<Map<String, String?>> _getPlaceDetails(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return {};

      final place = placemarks.first;
      return {
        'placeName': place.name,
        'address': _buildAddress(place),
        'city': place.locality ?? place.subAdministrativeArea,
        'country': place.country,
      };
    } catch (e) {
      print('Reverse geocoding error: $e');
      return {};
    }
  }

  String _buildAddress(Placemark place) {
    final addressParts =
        [
          place.subLocality,
          place.locality,
          place.administrativeArea,
          place.postalCode,
        ].where((part) => part != null && part.isNotEmpty).toList();

    return addressParts.join(', ');
  }

  @override
  Future<Either<String, List<LocationModel>>> searchLocation(
    String query,
  ) async {
    try {
      if (query.isEmpty) {
        return Left('Search query cannot be empty');
      }

      final locations = await locationFromAddress(query);
      if (locations.isEmpty) {
        return Left('No locations found for "$query"');
      }

      final results = <LocationModel>[];
      for (final location in locations) {
        try {
          final placeDetails = await _getPlaceDetails(
            location.latitude,
            location.longitude,
          );

          results.add(
            LocationModel(
              latitude: location.latitude,
              longitude: location.longitude,
              placeName: placeDetails['placeName'] ?? 'Unknown place',
              address: placeDetails['address'] ?? query,
              city: placeDetails['city'],
              country: placeDetails['country'],
            ),
          );
        } catch (e) {
          results.add(
            LocationModel(
              latitude: location.latitude,
              longitude: location.longitude,
              address: query,
            ),
          );
          continue;
        }
      }

      if (results.isEmpty) {
        return Left('Found locations but couldn\'t get details');
      }
      return Right(results);
    } on PlatformException catch (e) {
      return Left('Location service error: ${e.message ?? 'Unknown error'}');
    } catch (e) {
      return Left('Failed to search location');
    }
  }

  @override
  Future<Either<String, String>> postAd(AdsModel ad) async {
    try {
      final docRef = await _firestore.collection("car_ads").add(ad.toMap());
      return Right(docRef.id);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, List<AdWithUserModel>>> getActiveAdsWithUsers() async {
    try {
      final adsSnapshot =
          await _firestore
              .collection('car_ads')
              .where('isActive', isEqualTo: true)
              .get();
      final ads =
          adsSnapshot.docs.map((doc) {
            return AdsModel.fromMap(doc.data(), doc.id);
          }).toList();
      final result = <AdWithUserModel>[];

      for (final ad in ads) {
        try {
          final userSnapShot =
              await _firestore.collection('Users').doc(ad.userId).get();
          result.add(AdWithUserModel(ad: ad, userData: userSnapShot.data()));
        } catch (e) {
          result.add(AdWithUserModel(ad: ad));
        }
      }
      return Right(result);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}
