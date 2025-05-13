import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:location/location.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';

abstract class FirebasePostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Either<String, List<BrandModel>>> getBrands();
  Future<Either<String, List<String>>> getModels(String brandId);
  Future<Either<String, List<FuelsModel>>> getFuel();
  Future<Either<String, LocationModel>> getCurrentLocation();
}

class PostFirebaseServiceImpl extends FirebasePostService {
  final Location _location = Location();
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
      print('Checking location service...');
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        print('Requesting location service...');
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print('Location services disabled');
          return Left('Location services are disabled');
        }
      }

      print('Checking location permissions...');
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        print('Requesting location permissions...');
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted) {
          print('Location permissions denied');
          return Left('Location permissions are denied');
        }
      }

      print('Getting current location...');
      final locationData = await _location.getLocation();
      print('Location data received: $locationData');

      if (locationData.latitude == null || locationData.longitude == null) {
        print('Invalid location data received');
        return Left('Failed to get valid location coordinates');
      }

      return Right(
        LocationModel(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
        ),
      );
    } catch (e) {
      print('Location error: $e');
      return Left('Failed to get location: ${e.toString()}');
    }
  }
}
