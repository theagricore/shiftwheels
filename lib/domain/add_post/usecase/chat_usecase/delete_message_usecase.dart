import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class DeleteMessageUseCase implements UseCase<Either<String, void>, DeleteMessageParams> {
  final PostRepository repository;

  DeleteMessageUseCase(this.repository);

  @override
  Future<Either<String, void>> call({DeleteMessageParams? param}) async {
    return await repository.deleteMessage(
      chatId: param!.chatId,
      messageId: param.messageId,
    );
  }
}

class DeleteMessageParams {
  final String chatId;
  final String messageId;

  DeleteMessageParams({
    required this.chatId,
    required this.messageId,
  });
}