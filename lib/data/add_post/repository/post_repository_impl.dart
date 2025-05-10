import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/add_post/data_source/firebase_post_service.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class PostRepositoryImpl extends PostRepository {
  @override
  Future<Either<String, List<BrandModel>>> getBrands() async {
    return await sl<FirebasePostService>().getBrands();
  }

  @override
  Future<Either<String, List<String>>> getModels(String brandId) async {
    if (brandId.isEmpty) {
      return Left('Brand ID cannot be empty');
    }
    
    final result = await sl<FirebasePostService>().getModels(brandId);
    
    return result.fold(
      (error) => Left(error),
      (models) => models.isEmpty 
        ? Left('No models found for this brand') 
        : Right(models),
    );
  }
  
  @override
  Future<Either<String, List<FuelsModel>>> getFuel() async {
    return await sl<FirebasePostService>().getFuel();
  }
}