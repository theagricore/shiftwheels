import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class MarkAsSoldUsecase implements UseCase<Either<String, void>, String> {
  final PostRepository repository;

  MarkAsSoldUsecase(this.repository);

  @override
  Future<Either<String, void>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('Ad ID cannot be empty');
    }
    return await repository.markAdAsSold(param);
  }
}