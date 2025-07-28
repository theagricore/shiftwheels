import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class SaveComparisonUseCase
    implements UseCase<Either<String, String>, Map<String, dynamic>> {
  final PostRepository repository;

  SaveComparisonUseCase(this.repository);

  @override
  Future<Either<String, String>> call({Map<String, dynamic>? param}) async {
    if (param == null || 
        param['userId'] == null || 
        param['carIds'] == null ||
        (param['carIds'] as List).length != 2) {
      return Left('Invalid parameters for saving comparison');
    }
    return await repository.saveComparison(
      userId: param['userId'] as String,
      carIds: List<String>.from(param['carIds']),
    );
  }
}