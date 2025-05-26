import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class UpdateAdUsecase implements UseCase<Either<String, void>, AdsModel> {
  final PostRepository repository;
  
  UpdateAdUsecase(this.repository);
  
  @override
  Future<Either<String, void>> call({AdsModel? param}) async {
    if (param == null || param.id == null || param.id!.isEmpty) {
      return Left('Ad ID cannot be empty');
    }
    return await repository.updateAd(param);
  }
}