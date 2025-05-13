import 'package:dartz/dartz.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/data/add_post/models/location_model.dart';

abstract class PostRepository {
  Future<Either<String, List<BrandModel>>> getBrands();
  Future<Either<String, List<String>>> getModels(String brandId);
  Future<Either<String, List<FuelsModel>>> getFuel();
  Future<Either<String, LocationModel>> getCurrentLocation();
}
