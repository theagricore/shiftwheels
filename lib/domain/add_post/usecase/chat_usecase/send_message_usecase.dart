import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class SendMessageUseCase implements UseCase<Either<String, void>, SendMessageParams> {
  final PostRepository repository;

  SendMessageUseCase(this.repository);

  @override
  Future<Either<String, void>> call({SendMessageParams? param}) async {
    return await repository.sendMessage(
      chatId: param!.chatId,
      senderId: param.senderId,
      content: param.content,
    );
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