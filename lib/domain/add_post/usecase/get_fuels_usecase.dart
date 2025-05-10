import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/fuels_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class GetFuelsUsecase implements UseCase<Either<String, List<FuelsModel>>, void> {
  @override
  Future<Either<String, List<FuelsModel>>> call({void param}) async {
    return await sl<PostRepository>().getFuel();
  }
}