import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class ToggleInterestUsecase implements UseCase<Either<String, void>, ToggleInterestParams> {
  final PostRepository repository;
  
  ToggleInterestUsecase(this.repository);
  
  @override
  Future<Either<String, void>> call({ToggleInterestParams? param}) async {
    if (param == null) {
      return Left('Parameters cannot be null');
    }
    return await repository.toggleInterest(param.adId, param.userId);
  }
}

class ToggleInterestParams {
  final String adId;
  final String userId;
  
  const ToggleInterestParams({
    required this.adId, 
    required this.userId,
  });
}