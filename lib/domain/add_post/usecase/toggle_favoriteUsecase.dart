import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class ToggleFavoriteUsecase implements UseCase<Either<String, void>, ToggleFavoriteParams> {
  final PostRepository repository;
  
  ToggleFavoriteUsecase(this.repository);
  
  @override
  Future<Either<String, void>> call({ToggleFavoriteParams? param}) async {
    if (param == null) {
      return Left('Parameters cannot be null');
    }
    return await repository.toggleFavorite(param.adId, param.userId);
  }
}

class ToggleFavoriteParams {
  final String adId;
  final String userId;
  
  ToggleFavoriteParams({required this.adId, required this.userId});
}