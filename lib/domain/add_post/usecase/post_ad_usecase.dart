import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/ads_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class PostAdUsecase implements UseCase<Either<String, String>, AdsModel> {
  final PostRepository repository;

  PostAdUsecase(this.repository);

  @override
  Future<Either<String, String>> call({AdsModel? param}) async {
    return await repository.postAd(param!);
  }
}