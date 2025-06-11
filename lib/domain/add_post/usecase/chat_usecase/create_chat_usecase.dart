import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class CreateChatUsecase implements UseCase<Either<String, String>, CreateChatParams> {
  final PostRepository repository;

  CreateChatUsecase(this.repository);

  @override
  Future<Either<String, String>> call({CreateChatParams? param}) async {
    if (param == null) {
      return Left('CreateChatParams cannot be null');
    }
    return await repository.createChat(param.adId, param.buyerId, param.sellerId);
  }
}

class CreateChatParams {
  final String adId;
  final String buyerId;
  final String sellerId;

  CreateChatParams({
    required this.adId,
    required this.buyerId,
    required this.sellerId,
  });
}