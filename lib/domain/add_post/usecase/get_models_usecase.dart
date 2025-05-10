import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';
import 'package:shiftwheels/service_locater/service_locater.dart';

class GetModelsUsecase implements UseCase<Either<String, List<String>>, String> {
  @override
  Future<Either<String, List<String>>> call({String? param}) async {
    return await sl<PostRepository>().getModels(param!);
  }
}