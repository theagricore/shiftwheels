import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/user_post_limit.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class CheckPostLimitUsecase implements UseCase<Either<String, UserPostLimit>, String> {
  final PostRepository repository;

  CheckPostLimitUsecase(this.repository);

  @override
  Future<Either<String, UserPostLimit>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('User ID cannot be empty');
    }
    return await repository.getUserPostLimit(param);
  }
}