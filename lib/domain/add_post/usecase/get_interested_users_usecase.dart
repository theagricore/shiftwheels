import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/auth/models/user_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetInterestedUsersUsecase implements UseCase<Either<String, List<UserModel>>, String> {
  final PostRepository repository;

  GetInterestedUsersUsecase(this.repository);

  @override
  Future<Either<String, List<UserModel>>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('Ad ID cannot be empty');
    }
    return await repository.getInterestedUsers(param);
  }
}