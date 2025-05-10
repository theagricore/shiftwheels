import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';

abstract class FirebasePostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<Either<String, List<BrandModel>>> getBrands();
  Future<Either<String, List<String>>> getModels(String brandId);
  Future<Either<String, List<FuelsModel>>> getFuel();
}

class PostFirebaseServiceImpl extends FirebasePostService {
  @override
  Future<Either<String, List<BrandModel>>> getBrands() async {
    try {
      final snapshot = await _firestore.collection('Brands').get();
      final brands = snapshot.docs.map((doc) {
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
      final snapshot = await _firestore
          .collection('Brands')
          .doc(brandId)
          .collection('Models')
          .get();

      final models = snapshot.docs
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
      final fuels = snapshot.docs.map((doc) {
        return FuelsModel(
          id: doc.id,
          fuels: doc['fuels'] as String? ?? '',
        );
      }).toList();
      return Right(fuels);
    } on FirebaseException catch (e) {
      return Left('Firebase error: ${e.message}');
    } catch (e) {
      return Left('Unexpected error: ${e.toString()}');
    }
  }
}