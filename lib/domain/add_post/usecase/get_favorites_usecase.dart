import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/ad_with_user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetFavoritesUsecase implements UseCase<Either<String, List<AdWithUserModel>>, String> {
  final PostRepository repository;
  
  GetFavoritesUsecase(this.repository);
  
  @override
  Future<Either<String, List<AdWithUserModel>>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('User ID cannot be empty');
    }
    return await repository.getUserFavorites(param);
  }
}