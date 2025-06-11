import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class SendMessageUsecase implements UseCase<Either<String, void>, SendMessageParams> {
  final PostRepository repository;

  SendMessageUsecase(this.repository);

  @override
  Future<Either<String, void>> call({SendMessageParams? param}) async {
    if (param == null) {
      return Left('SendMessageParams cannot be null');
    }
    return await repository.sendMessage(param.chatId, param.senderId, param.content);
  }
}

class SendMessageParams {
  final String chatId;
  final String senderId;
  final String content;

  SendMessageParams({
    required this.chatId,
    required this.senderId,
    required this.content,
  });
}