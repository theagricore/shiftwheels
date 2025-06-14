import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class CreateChatUseCase implements UseCase<Either<String, String>, CreateChatParams> {
  final PostRepository repository;

  CreateChatUseCase(this.repository);

  @override
  Future<Either<String, String>> call({CreateChatParams? param}) async {
    return await repository.createChat(
      adId: param!.adId,
      sellerId: param.sellerId,
      buyerId: param.buyerId,
    );
  }
}

class CreateChatParams {
  final String adId;
  final String sellerId;
  final String buyerId;

  CreateChatParams({
    required this.adId,
    required this.sellerId,
    required this.buyerId,
  });
}