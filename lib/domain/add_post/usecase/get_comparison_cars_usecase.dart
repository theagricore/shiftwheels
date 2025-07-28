import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetComparisonCarsUseCase
    implements UseCase<Either<String, List<AdWithUserModel>>, List<String>> {
  final PostRepository repository;

  GetComparisonCarsUseCase(this.repository);

  @override
  Future<Either<String, List<AdWithUserModel>>> call({List<String>? param}) async {
    if (param == null || param.length != 2) {
      return Left('Exactly two car IDs are required');
    }
    return await repository.getComparisonCars(param);
  }
}