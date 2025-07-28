import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/data/add_post/models/comparison_model.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class GetSavedComparisonsUseCase
    implements UseCase<Either<String, List<ComparisonModel>>, String> {
  final PostRepository repository;

  GetSavedComparisonsUseCase(this.repository);

  @override
  Future<Either<String, List<ComparisonModel>>> call({String? param}) async {
    if (param == null || param.isEmpty) {
      return Left('User ID cannot be empty');
    }
    return await repository.getSavedComparisons(param);
  }
}