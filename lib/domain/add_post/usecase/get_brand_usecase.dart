import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/brand_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';


class GetBrandUsecase implements UseCase<Either<String, List<BrandModel>>, void> {
  @override
  Future<Either<String, List<BrandModel>>> call({void param}) async {
    return await sl<PostRepository>().getBrands();
  }
}