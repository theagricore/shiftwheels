import 'package:dartz/dartz.dart';
import 'package:shiftwheels/core/usecase_model/usecase.dart';
import 'package:shiftwheels/domain/add_post/repository/post_repository.dart';

class MarkMessagesReadUseCase implements UseCase<Either<String, void>, MarkMessagesReadParams> {
  final PostRepository repository;

  MarkMessagesReadUseCase(this.repository);

  @override
  Future<Either<String, void>> call({MarkMessagesReadParams? param}) async {
    return await repository.markMessagesAsRead(
      chatId: param!.chatId,
      userId: param.userId,
    );
  }
}

class MarkMessagesReadParams {
  final String chatId;
  final String userId;

  MarkMessagesReadParams({
    required this.chatId,
    required this.userId,
  });
}