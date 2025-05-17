import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetActiveAdsUsecase implements UseCase<Either<String, List<AdWithUserModel>>, void> {
  final PostRepository repository;

  GetActiveAdsUsecase(this.repository);

  @override
  Future<Either<String, List<AdWithUserModel>>> call({void param}) async {
    return await repository.getActiveAdsWithUsers();
  }
}